Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677EB214A89
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188444; cv=none; b=m+XwMcWMnCpbCJ+zfxKKLlUEYDkns+94MRBtescL5BAG+VILWBIs4Mtdtm1GKfJbSf6IAP3l/LPJlOzxJPjPNmBRP3cK9JQTzy1GSn5oWn7lh53LvUYmDUL8eutmFnP0JzDnznLiB1cfd0A04I1qyFiEo4xpG8w5NPCQZSW4S6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188444; c=relaxed/simple;
	bh=7ZaP4gp7PSsjTpYiVqAXjefYbs5aikHfb74tW8St7Mg=;
	h=Date:To:From:Subject:Message-Id; b=NF6/6uFb6nh0qjD2HWo+rwB2pg1P6Sz4uZbDFeJfCtrp7a9Uin2D6vB1lqW+0r19iB1If65gUAmIMa7yY0cnsmNbXAhXw+TE/+ycNNjDW9Co1ppedp9HdNM1+zSBuTdpMJBzjIloaI/Ft4co6NQBCQPip6LDuRxFqr+E8KCdt2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=towwpwo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="towwpwo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA18C4CEEC;
	Mon, 17 Mar 2025 05:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188444;
	bh=7ZaP4gp7PSsjTpYiVqAXjefYbs5aikHfb74tW8St7Mg=;
	h=Date:To:From:Subject:From;
	b=towwpwo1SdFMEVO79QBJDNSe90NjWA4ytdIIAG2HBUqk3h5beOdoxCiaro1XdX1U+
	 TWDNT+USeAOZ6wvdQDYQn/SvqMsdJOC1toW+wE11/uqCjgw5CVUAQEtgWig/HbCYPh
	 oK2ZLi7jM8x/fz2gIpfUZiQ95bbAXzcddF6Eyh7w=
Date: Sun, 16 Mar 2025 22:14:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-skip-map_populate-on-weird-filesystems.patch removed from -mm tree
Message-Id: <20250317051404.3CA18C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: skip map_populate on weird filesystems
has been removed from the -mm tree.  Its filename was
     selftests-mm-skip-map_populate-on-weird-filesystems.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: skip map_populate on weird filesystems
Date: Tue, 11 Mar 2025 13:18:18 +0000

It seems that 9pfs does not allow truncating unlinked files, Mark Brown
has noted that NFS may also behave this way.

It doesn't seem quite right to call this a "bug" but it's probably a
special enough case that it makes sense for the test to just SKIP if it
happens.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-7-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/map_populate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/map_populate.c~selftests-mm-skip-map_populate-on-weird-filesystems
+++ a/tools/testing/selftests/mm/map_populate.c
@@ -87,6 +87,13 @@ int main(int argc, char **argv)
 	BUG_ON(!ftmp, "tmpfile()");
 
 	ret = ftruncate(fileno(ftmp), MMAP_SZ);
+	if (ret < 0 && errno == ENOENT) {
+		/*
+		 * This probably means tmpfile() made a file on a filesystem
+		 * that doesn't handle temporary files the way we want.
+		 */
+		ksft_exit_skip("ftruncate(fileno(tmpfile())) gave ENOENT, weird filesystem?\n");
+	}
 	BUG_ON(ret, "ftruncate()");
 
 	smap = mmap(0, MMAP_SZ, PROT_READ | PROT_WRITE,
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

