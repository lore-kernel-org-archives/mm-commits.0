Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4199E39E9A0
	for <mm-commits@vger.kernel.org>; Wed, 17 Jun 2026 22:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781735905; cv=none; b=WOdKAMdg/2VY9JyPlfnEyeFATkmIvblovrLh00OGVzLgwYNePawg0zyD73mCHaG/Wxgzx2idNFNRw9w6iXJq9UURL8RGt7hiA+Habv2XDkl1zNUwD8ky419M2L1KDvPVHdLt9vjzLoGNbS4ZAh81KhlDdpyiCwQA7vCAXpD5EEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781735905; c=relaxed/simple;
	bh=PvDdXZGmzLl9zAvS46XftYZAbRtZw/Y5C4omenS9kEg=;
	h=Date:To:From:Subject:Message-Id; b=Xd3cdg5PeGb3D9XR7GCCrcr2MV8nl6+/w12jT5UJIxIGjCFDZwHSI+y1WRxqRgKVwBXFbr1DgwMBHFc5T23myYCMwRWtpNMhoHQhuc0i3TJFU2yDh7fZKzsB6vdm7JIXLqG0ShrIOP8k4DBy4J0aIP/0hS53E9efbW01qfRpUl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JgDwWiuG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JgDwWiuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95EB1F00A3A;
	Wed, 17 Jun 2026 22:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781735903;
	bh=1WPWAuLUwUaNyQlux8b80LlWlD8CL8VuuEps6Q/nmLg=;
	h=Date:To:From:Subject;
	b=JgDwWiuGrJQozyKnx1LCDu4Epv7DnBA70rxNbkieqXsxE0Y1u8iv7V40rQfUrpzx7
	 2pzdVdfyMIYDAHFXy2JJP+KrM2MeAD0Y+vKW1TJK7fgMax3nhvY62VM7EAKIXddto+
	 ka/5Rq781+wPHvSuyGKp2eTh+LRK2+un3VN1VXFg=
Date: Wed, 17 Jun 2026 15:38:23 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch removed from -mm tree
Message-Id: <20260617223823.C95EB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: reject BPB volumes whose data area starts beyond total sectors
has been removed from the -mm tree.  Its filename was
     fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Moelius <sam.moelius@trailofbits.com>
Subject: fat: reject BPB volumes whose data area starts beyond total sectors
Date: Fri, 5 Jun 2026 15:52:15 +0000

fat_fill_super() subtracts sbi->data_start from the BPB total sector count
before computing the number of clusters.  A malformed image can declare a
total sector count smaller than data_start, causing the subtraction to
underflow and the mount code to derive a plausible cluster count from the
FAT length instead.

Reject such images before the subtraction.  In QEMU, a crafted FAT image
with total_sectors=2 and data_start=3 mounted successfully before the fix
and reading a file returned bytes stored past the BPB-declared end of the
volume.  With this change, the same image is rejected during mount.

Assisted-by: Codex:gpt-5.5-cyber-preview
Link: https://lore.kernel.org/20260605155216.2126545-1-sam.moelius@trailofbits.com
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/fat/inode.c~fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors
+++ a/fs/fat/inode.c
@@ -1738,6 +1738,14 @@ int fat_fill_super(struct super_block *s
 	if (total_sectors == 0)
 		total_sectors = bpb.fat_total_sect;
 
+	if (total_sectors < sbi->data_start) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"data area starts beyond volume (%lu > %u)",
+				sbi->data_start, total_sectors);
+		goto out_invalid;
+	}
+
 	total_clusters = (total_sectors - sbi->data_start) / sbi->sec_per_clus;
 
 	if (!is_fat32(sbi))
_

Patches currently in -mm which might be from sam.moelius@trailofbits.com are

mm-page_frag-reject-invalid-cpus-in-page_frag_test.patch
mm-gup_test-reject-wrapped-user-ranges.patch

