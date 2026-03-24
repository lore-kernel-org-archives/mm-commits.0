Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9435F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388482; cv=none; b=k2Hfmz28lj41no2oGU61jGoiCtBukMYPu/hQs1cyYawvy7kqo+gSka096WXk1PAp7EOQRb1MQExG2E4g+CU4fXp74cNjPcEVmmXnM1il2k2/9encNrbgJ0fA3OBWEU5LoLUAoKItwQGwPRGaV76ddsAat50vWmbAZiJ5asAPzvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388482; c=relaxed/simple;
	bh=OnElDooTbLEQx7GFQTQssuON2MwSbD//5VXloyxrRO0=;
	h=Date:To:From:Subject:Message-Id; b=PcWgvFO4frAH25jpl7+AzZoYjibaAk2ALN/ahIzJb1Jzf4/Y7CyY0CXMdZr+wjCnB7Baxwi7x2WFKHC0S6w9DRkpt9/MW+pVzThfBHs1rs8MMWeXXaSGcYgcUWDeYCnxcm17AkmdLO2Q0z8ITFOAZkgqGa0pC4rW3jVFG/t/Ygo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRnQMeKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRnQMeKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7EBC19424;
	Tue, 24 Mar 2026 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388482;
	bh=OnElDooTbLEQx7GFQTQssuON2MwSbD//5VXloyxrRO0=;
	h=Date:To:From:Subject:From;
	b=wRnQMeKYoxEV9mLe14VbUvyVSDecKKZ1q3QjmCXNqpEhlFeDPicPI6k3/edgUGHnv
	 amm2wC/UjJ9yYt+SPeoQfLNP9kcPcL3iSfjIUIveWvV5gsI5kuoZKg3ckUdh9GZE84
	 4XvflBlw+tX4LROAcNRtuaguSinaqoE8Ki4EXQYE=
Date: Tue, 24 Mar 2026 14:41:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,k.lourenco@criteo.com,jack@suse.cz,david@kernel.org,brauner@kernel.org,klourencodev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fadvise-validate-offset-in-generic_fadvise.patch removed from -mm tree
Message-Id: <20260324214122.7C7EBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/fadvise: validate offset in generic_fadvise
has been removed from the -mm tree.  Its filename was
     mm-fadvise-validate-offset-in-generic_fadvise.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Lourenco <klourencodev@gmail.com>
Subject: mm/fadvise: validate offset in generic_fadvise
Date: Mon, 22 Dec 2025 15:18:17 +0100

When converted to (u64) for page calculations, a negative offset can
produce extremely large page indices.  This may lead to issues in certain
advice modes (excessive readahead or cache invalidation).

Reject negative offsets with -EINVAL for consistent argument validation
and to avoid silent misbehavior.

POSIX and the man page do not clearly define behavior for negative
offset/len.  FreeBSD rejects negative offsets as well, so failing with
-EINVAL is consistent with existing practice.  The man page can be updated
separately to document the Linux behavior.

Link: https://lkml.kernel.org/r/20260208135738.18992-1-klourencodev@gmail.com
Link: https://lkml.kernel.org/r/20251222141817.13335-1-klourencodev@gmail.com
Signed-off-by: Kevin Lourenco <k.lourenco@criteo.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/fadvise.c~mm-fadvise-validate-offset-in-generic_fadvise
+++ a/mm/fadvise.c
@@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, l
 		return -ESPIPE;
 
 	mapping = file->f_mapping;
-	if (!mapping || len < 0)
+	if (!mapping || len < 0 || offset < 0)
 		return -EINVAL;
 
 	bdi = inode_to_bdi(mapping->host);
_

Patches currently in -mm which might be from klourencodev@gmail.com are


