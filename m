Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585316;
	b=sGq/n9XR+LQePiopv4jVjzHcdlTUgzXHnO5C3Bs2sdRCOtl1FLYPVNs+ncrkZxxZ5LQ/
	 QT22Z/tBUmF/ovk8eseeWXob1XHoXYXkvSYC6TOlNgac/WA2tRf7DfMKDdA/VuQyCUrCg
	 EmCJMbXfTZTGl0niL24q1zKo/dLG5ecewoZTF5wB5LX1jwlnGJnlZJLcHqGRQTc5+W+oK
	 ciB2xhIpGV8xswV4nCs/HPfolfREeANfcUZbxBY8ZooXph9nQ1jaV6nqN2QTZhvLqvVXn
	 HZ6ZNmAJhv6qPSFksVh6KEd/4FWitwL8oWUBsMoFPJIOHc+t5KheFBfzyLyEzArTwNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585316;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=FV4U9g9G7OpZ60p2Bdrtjbc354Oo9hDDtzHz5xHWlSI=;
	b=F9Eij2sCU6km4JfQLQ1FLbXluhw8H2WvmuSw5EyQlR8irZzI9QoIY/tObxc0At8dMlya
	 gJFOYmqJC2fYhqzWMU4I8gMXJ/DaKCCKhlXVmttqR8E2kezx9y7KjwHvhozSZnF52ZZ22
	 kNM2CdeDF924RRUu/HZPKbiD4kfxYrtkYh4v9n3vD5giuuvtUWXUzxftrjqqY9cQD+SO7
	 bAHhVeXBipfezGN8Pj0T2vsIUNeAWEGJSL4IiMsCwhxtUsVYCrDh9WdbrzzCtNtmnAyOp
	 uo/fa8pPhhzrDpfztR1qH8tKf26Zff9jeEONj6cgfjHeKUcH2OnXQv35VDejDzIlYdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iuHxG0kr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5503E606A326
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iuHxG0kr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94F41F000D2;
	Wed, 25 Nov 2026 05:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585316;
	bh=FV4U9g9G7OpZ60p2Bdrtjbc354Oo9hDDtzHz5xHWlSI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=iuHxG0krWsV/OvOIhzf/FkPsbYxo++EuoTyB6nPIVJpqpVKMTjf3DGC0HPSSLDon6
	 FYhEjIVw4MnJ8jycerH9kko5Km6RlHO/Go6DKYS8BPiPTmUpaYYfhZhnLjt4+gtuFq
	 3/wu9jDy2G30BYV59zaGCo5Yk5vPcWNf9h74Iaew=
Date: Tue, 24 Nov 2026 21:41:55 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-20-phillip@squashfs.org.uk>
References: <20261123034304.261742-20-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-dont-store-large-fragment-table-indexes-in-memory.patch removed from -mm tree
Message-Id: <20261125054155.D94F41F000D2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: don't store large fragment table indexes in memory
has been removed from the -mm tree.  Its filename was
     squashfs-dont-store-large-fragment-table-indexes-in-memory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/fragment.c         |   99 ++++++++++++++++++++++++-------
 fs/squashfs/squashfs.h         |    3 
 fs/squashfs/squashfs_fs_sb.h   |    8 ++
 fs/squashfs/squashfs_helpers.h |   28 ++++++++
 fs/squashfs/super.c            |   32 ++++++----
 5 files changed, 136 insertions(+), 34 deletions(-)

--- a/fs/squashfs/fragment.c~squashfs-dont-store-large-fragment-table-indexes-in-memory
+++ a/fs/squashfs/fragment.c
@@ -29,26 +29,67 @@
 #include "squashfs_helpers.h"
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
 				u64 *fragment_block, int *fragment_size)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int block, offset, size;
+	s32 offset, size;
 	struct squashfs_fragment_entry fragment_entry;
-	u64 start_block;
+	s64 start;
 
 	if (fragment >= msblk->fragments)
 		return -EIO;
-	block = squashfs_fragment_index(fragment);
-	offset = squashfs_fragment_index_offset(fragment);
 
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
@@ -57,16 +98,14 @@ int squashfs_frag_lookup(struct super_bl
 	*fragment_size = le32_to_cpu(fragment_entry.size);
 	return 0;
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
-	unsigned int length = squashfs_fragment_index_bytes(fragments);
-	__le64 *table;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s32 length = squashfs_fragment_indexes_bytes(fragments);
 
 	/*
 	 * The computed size of the index table (length bytes) should exactly
@@ -74,18 +113,36 @@ __le64 *squashfs_read_fragment_index_tab
 	 */
 	if (fragment_table_start >= next_table ||
 				length != (next_table - fragment_table_start))
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 
-	table = squashfs_read_table(sb, fragment_table_start, length);
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
 
-	/*
-	 * table[0] points to the first fragment table metadata block, this
-	 * should be less than fragment_table_start
-	 */
-	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= fragment_table_start) {
-		kfree(table);
-		return ERR_PTR(-EINVAL);
+		if (IS_ERR(cache))
+			return PTR_ERR(cache);
+
+		msblk->fragment_index_cache = cache;
+		msblk->fragment_index_is_cache = true;
 	}
 
-	return table;
+	return 0;
 }
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-dont-store-large-fragment-table-indexes-in-memory
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -59,7 +59,10 @@ struct squashfs_sb_info {
 	struct address_space			*cache_mapping;
 	int					next_meta_index;
 	__le64					*id_table;
-	__le64					*fragment_index;
+	union {
+		__le64				*fragment_index_array;
+		struct squashfs_cache		*fragment_index_cache;
+	};
 	__le64					*xattr_id_table;
 	struct mutex				meta_index_mutex;
 	struct meta_index			*meta_index;
@@ -71,6 +74,8 @@ struct squashfs_sb_info {
 	u64					inode_table;
 	u64					directory_table;
 	u64					directory_table_end;
+	u64					fragment_table;
+	u64					fragment_table_start;
 	u64					xattr_table;
 	u64					lookup_table;
 	u64					lookup_table_start;
@@ -85,5 +90,6 @@ struct squashfs_sb_info {
 	const struct squashfs_decompressor_thread_ops *thread_ops;
 	int					max_thread_num;
 	bool					lookup_table_is_cache;
+	bool					fragment_index_is_cache;
 };
 #endif
--- a/fs/squashfs/squashfs.h~squashfs-dont-store-large-fragment-table-indexes-in-memory
+++ a/fs/squashfs/squashfs.h
@@ -71,8 +71,9 @@ extern s64 squashfs_inode_lookup_start(s
 /* fragment.c */
 extern int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
 				u64 *fragment_block, int *fragment_size);
-extern __le64 *squashfs_read_fragment_index_table(struct super_block *,
+extern int squashfs_read_fragment_index_table(struct super_block *,
 				u64, u64, unsigned int);
+extern s64 squashfs_frag_lookup_start(struct super_block *sb, u32 fragment);
 
 /* file.c */
 void squashfs_copy_cache(struct folio *, struct squashfs_cache_entry *,
--- a/fs/squashfs/squashfs_helpers.h~squashfs-dont-store-large-fragment-table-indexes-in-memory
+++ a/fs/squashfs/squashfs_helpers.h
@@ -108,11 +108,37 @@ static inline s32 squashfs_fragment_inde
 		SQUASHFS_METADATA_SIZE;
 }
 
-static inline s32 squashfs_fragment_index_bytes(u32 fragments)
+static inline s32 squashfs_fragment_indexes_bytes(u32 fragments)
 {
 	return squashfs_fragment_indexes(fragments) * sizeof(long long);
 }
 
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
 /* inode lookup table defines */
 static inline s64 squashfs_lookup_bytes(u32 inodes)
 {
--- a/fs/squashfs/super.c~squashfs-dont-store-large-fragment-table-indexes-in-memory
+++ a/fs/squashfs/super.c
@@ -185,6 +185,14 @@ static void squashfs_free_inode_table(st
 		kfree(msblk->inode_lookup_array);
 }
 
+static void squashfs_free_fragment_indexes(struct squashfs_sb_info *msblk)
+{
+	if (msblk->fragment_index_is_cache)
+		squashfs_cache_delete(msblk->fragment_index_cache);
+	else
+		kfree(msblk->fragment_index_array);
+}
+
 static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct squashfs_mount_opts *opts = fc->fs_private;
@@ -300,6 +308,7 @@ static int squashfs_fill_super(struct su
 
 	msblk->inode_table = le64_to_cpu(sblk->inode_table_start);
 	msblk->directory_table = le64_to_cpu(sblk->directory_table_start);
+	msblk->fragment_table = le64_to_cpu(sblk->fragment_table_start);
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	msblk->fragments = le32_to_cpu(sblk->fragments);
 	msblk->ids = le16_to_cpu(sblk->no_ids);
@@ -317,8 +326,7 @@ static int squashfs_fill_super(struct su
 	TRACE("Number of ids %d\n", msblk->ids);
 	TRACE("sblk->inode_table_start %llx\n", msblk->inode_table);
 	TRACE("sblk->directory_table_start %llx\n", msblk->directory_table);
-	TRACE("sblk->fragment_table_start %llx\n",
-		(u64) le64_to_cpu(sblk->fragment_table_start));
+	TRACE("sblk->fragment_table_start %llx\n", msblk->fragment_table);
 	TRACE("sblk->id_table_start %llx\n",
 		(u64) le64_to_cpu(sblk->id_table_start));
 
@@ -433,15 +441,19 @@ handle_fragments:
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
@@ -493,7 +505,7 @@ failed_mount:
 		iput(msblk->cache_mapping->host);
 	msblk->thread_ops->destroy(msblk);
 	squashfs_free_inode_table(msblk);
-	kfree(msblk->fragment_index);
+	squashfs_free_fragment_indexes(msblk);
 	kfree(msblk->id_table);
 	kfree(msblk->xattr_id_table);
 	kfree(sb->s_fs_info);
@@ -613,7 +625,7 @@ static void squashfs_put_super(struct su
 			iput(sbi->cache_mapping->host);
 		sbi->thread_ops->destroy(sbi);
 		kfree(sbi->id_table);
-		kfree(sbi->fragment_index);
+		squashfs_free_fragment_indexes(sbi);
 		kfree(sbi->meta_index);
 		squashfs_free_inode_table(sbi);
 		kfree(sbi->xattr_id_table);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

