Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB452E541E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 02:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482667; cv=none; b=puNJeBsWVxVL9Zlw3bgN3j0GSW1B220TEPJWUBzrx/nH9FfCoD37cjW7sglauKvYVpNUtCLLw6iifnq4ilg9OobYp6xFJReGBNOzTrsWsaJKGXpmfOjJCZsnpvhl1yE5irbX0mh6B964kxEmA9c9EfCu/oLHQXHvVYHdlH2KzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482667; c=relaxed/simple;
	bh=DKNTj9QIG4zONdlWchdKk2IHhmOK97Xx29r0qzFzsfw=;
	h=Date:To:From:Subject:Message-Id; b=aZIAKEDPUkoFYmLWkexJyRq7Nq8rru7GTx//tRn7O/bRGWF4pOdsVuMyoVx8imXap8F/39E+rctdMUdlD21aDeuHnr6VlmQiTLtpQV+C38XoUr7MAGtC2AYlOvj9NK1r/CJMykVFWil1Ma0qK++Tgc2UDbOSnq8+PnLHlBk3yG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uLIoYwkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uLIoYwkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBE3C116C6;
	Tue, 27 Jan 2026 02:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482666;
	bh=DKNTj9QIG4zONdlWchdKk2IHhmOK97Xx29r0qzFzsfw=;
	h=Date:To:From:Subject:From;
	b=uLIoYwkYTU+Kx1mRKBh+kqFdmO5Hiy31c6smjfrnGDS+irWq8QhyKnabPr7uPGqJD
	 EmLkJ9gG4Mci6+GAAreHKJThCBKuuAVEgbC2Q8wearU13TsHfPkeOEgIBgxs/Hq8xP
	 mdKOu56FEg4MBhCc7GWXwyV8dOuz2V0VKOpOzBs0=
Date: Mon, 26 Jan 2026 18:57:46 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,hughd@google.com,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch removed from -mm tree
Message-Id: <20260127025746.BBBE3C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memfd_luo: restore and free memfd_luo_ser on failure
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: mm: memfd_luo: restore and free memfd_luo_ser on failure
Date: Thu, 22 Jan 2026 16:18:41 +0100

memfd_luo_ser has the serialization metadata.  It is of no use once
restoration fails.  Free it on failure.

Link: https://lkml.kernel.org/r/20260122151842.4069702-4-pratyush@kernel.org
Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-restore-and-free-memfd_luo_ser-on-failure
+++ a/mm/memfd_luo.c
@@ -447,7 +447,8 @@ static int memfd_luo_retrieve(struct liv
 	file = memfd_alloc_file("", 0);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		return PTR_ERR(file);
+		err = PTR_ERR(file);
+		goto free_ser;
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
@@ -473,7 +474,8 @@ static int memfd_luo_retrieve(struct liv
 
 put_file:
 	fput(file);
-
+free_ser:
+	kho_restore_free(ser);
 	return err;
 }
 
_

Patches currently in -mm which might be from pratyush@kernel.org are

liveupdate-luo_file-do-not-clear-serialized_data-on-unfreeze.patch
liveupdate-luo_file-remember-retrieve-status.patch
memfd-export-memfd_addget_seals.patch
mm-memfd_luo-preserve-file-seals.patch
kho-use-unsigned-long-for-nr_pages.patch
kho-simplify-page-initialization-in-kho_restore_page.patch

