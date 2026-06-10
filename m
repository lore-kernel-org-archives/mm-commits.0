Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5785333260B
	for <mm-commits@vger.kernel.org>; Wed, 10 Jun 2026 21:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781127052; cv=none; b=hGDWAjEvqpoUpZoyDLBES9vWMuUy1omBgCyyCCM/Fge0E3DFAH6NrtMV290eQLYlht5HRuvXjos5xD6Pp7bsdt7P1P8kGEqbMT3OVjH6+Zd/OFMY0YesFm8BoCQljQYQ2TZ/6Z+nigqSywXuOnpAvK/agfUbOS3FNQP8kXV9vIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781127052; c=relaxed/simple;
	bh=dTrywszZHpU+D77hhPacW/3ApF8PBW7TXPJGXJXogwM=;
	h=Date:To:From:Subject:Message-Id; b=WqwS7N30UKsdK4FGwkPtkizgKpsAMkHEH87gmj/8lAHFvZayZ1GonsGIjFHNkHnwvm2xNO8SeCqvc3KpX7/HESV32aRakXF0DfaCZ9xrRIy9yMb0eTvKGUG22g/0fs9oWmWvdBSX5p8twqIps6rSLgJ15x0ROgMHZj5og8imZJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWf2idnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWf2idnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B4C1F00899;
	Wed, 10 Jun 2026 21:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781127051;
	bh=yccaQAh/yPXUpSronjSZfn7KPd8onDCTWS4MHC8V4AI=;
	h=Date:To:From:Subject;
	b=tWf2idnJlasKh8kpAl3bJNdL6FzkXGJ/KznhB3QTUO5YAEzSy9i8Csh8jjHS4BinC
	 TxIpbTv0gOCWaC2Ec4nRyMEpkcBJvXCPkKe0SLmJvS18z05SLN1QJdP8gBST43OGZ+
	 3JzwsdkmdnxrMxhoLHDZgPoCcFDfPJ3dZrzme5lA=
Date: Wed, 10 Jun 2026 14:30:50 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,sam.moelius@trailofbits.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch added to mm-nonmm-unstable branch
Message-Id: <20260610213050.E8B4C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: reject BPB volumes whose data area starts beyond total sectors
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
lib-test_firmware-allocate-the-configured-into_buf-size.patch
lib-interval_tree_test-validate-benchmark-parameters.patch
fat-reject-bpb-volumes-whose-data-area-starts-beyond-total-sectors.patch

