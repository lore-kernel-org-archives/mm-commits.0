Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD71C217723
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788460867; cv=none; b=Gcs6dapINEwELLzKEFDFN6H1KOWju56IN2zTSihBPJhHSx0qejapk8vOPzwReuO6A8iHAF/YoHGaBfsHFiM6eLund4+xuhUdwSStRRlbWvvzopWHZ3n9rZ09SngcItF5E3GNopa5kpQt75R+jj85S47sCZwDM+JejWqI3PqHg3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788460867; c=relaxed/simple;
	bh=Hxo8CIUCQfANPdxe5VYr+0fmQUJmNmQ2wMRBb5unR2U=;
	h=Date:To:From:Subject:Message-Id; b=GfHq8budF+9wZvndoLMMILFmLMI3atz154mMipF/ZWlsBKOKluxuYFrPzfg70HOUVIctRAZACjxwGUAw8I2WT84HiN9x+/W3pU/AFmPcXTx2y6R+OA4KDOAh50ThuVz0Q/OAAI85FZYc4ZtUSCknHsQyO8awaIufVMI5bZUOt8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UuAJEGcx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UuAJEGcx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B94C1F000E9;
	Thu,  3 Sep 2026 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788460862;
	bh=Q5Qe3fz6uE50AQb3aHSmjFlYotwQKibOklu5+1DBMpQ=;
	h=Date:To:From:Subject;
	b=UuAJEGcxOhmJi9t0XMb42ZZVetXUDtEu4xF2PF4GKbSWHf+TBn5UtL60BVIybkEtB
	 tkRrBSJydNO8VgCqu2ViRlBY9To7ebMGV+sPtm3Bksftfiy6BrNDWJUB+fi9cCiCkl
	 P6/en9hKYBD+0NkYdPa8LQssy09nGK5GDqGFddFk=
Date: Thu, 03 Sep 2026 11:41:01 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,hengyul@cs.unc.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-calculate-data-area-start-without-overflow.patch added to mm-nonmm-unstable branch
Message-Id: <20260903184102.2B94C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: calculate data area start without overflow
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-calculate-data-area-start-without-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-calculate-data-area-start-without-overflow.patch

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
From: Hengyu Liang <hengyul@cs.unc.edu>
Subject: fat: calculate data area start without overflow
Date: Wed, 2 Sep 2026 13:01:15 -0400

On 32-bit architectures, sbi->fat_length, sbi->dir_start and
sbi->data_start are unsigned long.  The number of FATs is an 8-bit BPB
field, while the FAT32 length is a 32-bit BPB field.  Therefore, the
calculation

    sbi->fat_start + sbi->fats * sbi->fat_length

can wrap before data_start is checked against total_sectors.

For example, with fat_start=32, fats=2 and fat_length=0x80000001, the
unwrapped data area start is 0x100000022 (4294967330), but the calculation
wraps to 34 on i386.  With total_sectors=36, the validation then
incorrectly passes.

The following script creates an image that demonstrates the problem:

    python3 - <<'PY'
    import struct

    S = 512
    b = bytearray(36 * S)

    def p(off, fmt, value):
        struct.pack_into(fmt, b, off, value)

    # FAT32 BPB
    b[0:3] = b'\xeb\x58\x90'
    b[3:11] = b'MSWIN4.1'
    p(11, '<H', 512)
    b[13] = 1
    p(14, '<H', 32)             # reserved sectors
    b[16] = 2                   # number of FATs
    p(17, '<H', 0)
    p(19, '<H', 0)
    b[21] = 0xf8
    p(22, '<H', 0)
    p(24, '<H', 1)
    p(26, '<H', 1)
    p(32, '<I', 36)             # total sectors
    p(36, '<I', 0x80000001)     # FAT32 length
    p(44, '<I', 2)              # root cluster
    p(48, '<H', 1)              # FSINFO sector
    b[64] = 0x80
    b[66] = 0x29
    p(67, '<I', 0x12345678)
    b[71:82] = b'OVERFLOW   '
    b[82:90] = b'FAT32   '
    b[510:512] = b'\x55\xaa'

    # FSINFO
    p(S, '<I', 0x41615252)
    p(S + 484, '<I', 0x61417272)
    p(S + 488, '<I', 0xffffffff)
    p(S + 492, '<I', 0xffffffff)

    # Wrapped FAT starts at sector 32
    fat = 32 * S
    p(fat + 8, '<I', 0x0fffffff)   # FAT[2]
    p(fat + 12, '<I', 0x0fffffff)  # FAT[3]

    # Wrapped data_start == 34
    root = 34 * S
    b[root:root + 11] = b'ESCAPE  TXT'
    b[root + 11] = 0x20
    p(root + 26, '<H', 3)
    p(root + 28, '<I', 4)
    b[35 * S:35 * S + 4] = b'OOB!'

    open('fat-overflow.img', 'wb').write(b)
    PY

Attach fat-overflow.img as /dev/sdb and run:

    mount -t vfat -o ro /dev/sdb /mnt
    cat /mnt/ESCAPE.TXT

On an unpatched i386 kernel, the mount succeeds and reading the file
returns:

    OOB!

On an x86-64 kernel and on a patched i386 kernel, mounting is rejected
with:

    mount: mounting /dev/sdb on /mnt failed: Invalid argument

Calculate dir_start and data_start in u32 using check_mul_overflow() and
check_add_overflow().  Since total_sectors is also a u32 value, any result
that overflows u32 cannot describe a valid volume.  Reject such layouts
before storing the values in the existing unsigned long fields.  The
existing total_sectors check handles values that fit in u32 but still lie
beyond the volume.

Link: https://lore.kernel.org/20260902170115.4162222-1-hengyul@cs.unc.edu
Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/fs/fat/inode.c~fat-calculate-data-area-start-without-overflow
+++ a/fs/fat/inode.c
@@ -20,6 +20,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/unaligned.h>
+#include <linux/overflow.h>
 #include <linux/random.h>
 #include <linux/iversion.h>
 #include <linux/fs_struct.h>
@@ -1577,6 +1578,7 @@ int fat_fill_super(struct super_block *s
 	struct msdos_sb_info *sbi;
 	u16 logical_sector_size;
 	u32 total_sectors, total_clusters, fat_clusters, rootdir_sectors;
+	u32 dir_start, data_start;
 	long error;
 	char buf[50];
 	struct timespec64 ts;
@@ -1752,7 +1754,6 @@ int fat_fill_super(struct super_block *s
 	sbi->dir_per_block = sb->s_blocksize / sizeof(struct msdos_dir_entry);
 	sbi->dir_per_block_bits = ffs(sbi->dir_per_block) - 1;
 
-	sbi->dir_start = sbi->fat_start + sbi->fats * sbi->fat_length;
 	sbi->dir_entries = bpb.fat_dir_entries;
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
@@ -1763,20 +1764,30 @@ int fat_fill_super(struct super_block *s
 
 	rootdir_sectors = sbi->dir_entries
 		* sizeof(struct msdos_dir_entry) / sb->s_blocksize;
-	sbi->data_start = sbi->dir_start + rootdir_sectors;
+	if (check_mul_overflow(sbi->fats, sbi->fat_length, &dir_start) ||
+	    check_add_overflow(sbi->fat_start, dir_start, &dir_start) ||
+	    check_add_overflow(dir_start, rootdir_sectors, &data_start)) {
+		if (!silent)
+			fat_msg(sb, KERN_ERR,
+				"overflow of root dir or data layout");
+		goto out_invalid;
+	}
+
 	total_sectors = bpb.fat_sectors;
 	if (total_sectors == 0)
 		total_sectors = bpb.fat_total_sect;
 
-	if (total_sectors < sbi->data_start) {
+	if (total_sectors < data_start) {
 		if (!silent)
 			fat_msg(sb, KERN_ERR,
-				"data area starts beyond volume (%lu > %u)",
-				sbi->data_start, total_sectors);
+				"data area starts beyond volume (%u > %u)",
+				data_start, total_sectors);
 		goto out_invalid;
 	}
 
-	total_clusters = (total_sectors - sbi->data_start) / sbi->sec_per_clus;
+	sbi->dir_start = dir_start;
+	sbi->data_start = data_start;
+	total_clusters = (total_sectors - data_start) / sbi->sec_per_clus;
 
 	if (!is_fat32(sbi))
 		sbi->fat_bits = (total_clusters > MAX_FAT12) ? 16 : 12;
_

Patches currently in -mm which might be from hengyul@cs.unc.edu are

fat-calculate-data-area-start-without-overflow.patch

