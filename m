From: akpm@linux-foundation.org
Subject: [merged] ntfs-remove-private-wrapper-of-endian-helpers.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:59 -0700
Message-ID: <200904011839.n31Idx8E008862@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933436AbZDASm4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:42:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: remove private wrapper of endian helpers
has been removed from the -mm tree.  Its filename was
     ntfs-remove-private-wrapper-of-endian-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: remove private wrapper of endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

The base versions handle constant folding now and are shorter than these
private wrappers, use them directly.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/dir.c     |    4 
 fs/ntfs/inode.c   |    3 
 fs/ntfs/layout.h  |  333 +++++++++++++++++++++-----------------------
 fs/ntfs/logfile.h |    6 
 fs/ntfs/mft.c     |    2 
 fs/ntfs/super.c   |   50 +++---
 fs/ntfs/usnjrnl.h |   48 +++---
 7 files changed, 217 insertions(+), 229 deletions(-)

diff -puN fs/ntfs/dir.c~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/dir.c
--- a/fs/ntfs/dir.c~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/dir.c
@@ -32,8 +32,8 @@
 /**
  * The little endian Unicode string $I30 as a global constant.
  */
-ntfschar I30[5] = { const_cpu_to_le16('$'), const_cpu_to_le16('I'),
-		const_cpu_to_le16('3'),	const_cpu_to_le16('0'), 0 };
+ntfschar I30[5] = { cpu_to_le16('$'), cpu_to_le16('I'),
+		cpu_to_le16('3'),	cpu_to_le16('0'), 0 };
 
 /**
  * ntfs_lookup_inode_by_name - find an inode in a directory given its name
diff -puN fs/ntfs/inode.c~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/inode.c
--- a/fs/ntfs/inode.c~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/inode.c
@@ -1975,8 +1975,7 @@ int ntfs_read_inode_mount(struct inode *
 				goto em_put_err_out;
 			next_al_entry = (ATTR_LIST_ENTRY*)((u8*)al_entry +
 					le16_to_cpu(al_entry->length));
-			if (le32_to_cpu(al_entry->type) >
-					const_le32_to_cpu(AT_DATA))
+			if (le32_to_cpu(al_entry->type) > le32_to_cpu(AT_DATA))
 				goto em_put_err_out;
 			if (AT_DATA != al_entry->type)
 				continue;
diff -puN fs/ntfs/layout.h~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/layout.h
--- a/fs/ntfs/layout.h~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/layout.h
@@ -31,19 +31,8 @@
 
 #include "types.h"
 
-/*
- * Constant endianness conversion defines.
- */
-#define const_le16_to_cpu(x)	__constant_le16_to_cpu(x)
-#define const_le32_to_cpu(x)	__constant_le32_to_cpu(x)
-#define const_le64_to_cpu(x)	__constant_le64_to_cpu(x)
-
-#define const_cpu_to_le16(x)	__constant_cpu_to_le16(x)
-#define const_cpu_to_le32(x)	__constant_cpu_to_le32(x)
-#define const_cpu_to_le64(x)	__constant_cpu_to_le64(x)
-
 /* The NTFS oem_id "NTFS    " */
-#define magicNTFS	const_cpu_to_le64(0x202020205346544eULL)
+#define magicNTFS	cpu_to_le64(0x202020205346544eULL)
 
 /*
  * Location of bootsector on partition:
@@ -114,25 +103,25 @@ typedef struct {
  */
 enum {
 	/* Found in $MFT/$DATA. */
-	magic_FILE = const_cpu_to_le32(0x454c4946), /* Mft entry. */
-	magic_INDX = const_cpu_to_le32(0x58444e49), /* Index buffer. */
-	magic_HOLE = const_cpu_to_le32(0x454c4f48), /* ? (NTFS 3.0+?) */
+	magic_FILE = cpu_to_le32(0x454c4946), /* Mft entry. */
+	magic_INDX = cpu_to_le32(0x58444e49), /* Index buffer. */
+	magic_HOLE = cpu_to_le32(0x454c4f48), /* ? (NTFS 3.0+?) */
 
 	/* Found in $LogFile/$DATA. */
-	magic_RSTR = const_cpu_to_le32(0x52545352), /* Restart page. */
-	magic_RCRD = const_cpu_to_le32(0x44524352), /* Log record page. */
+	magic_RSTR = cpu_to_le32(0x52545352), /* Restart page. */
+	magic_RCRD = cpu_to_le32(0x44524352), /* Log record page. */
 
 	/* Found in $LogFile/$DATA.  (May be found in $MFT/$DATA, also?) */
-	magic_CHKD = const_cpu_to_le32(0x444b4843), /* Modified by chkdsk. */
+	magic_CHKD = cpu_to_le32(0x444b4843), /* Modified by chkdsk. */
 
 	/* Found in all ntfs record containing records. */
-	magic_BAAD = const_cpu_to_le32(0x44414142), /* Failed multi sector
+	magic_BAAD = cpu_to_le32(0x44414142), /* Failed multi sector
 						       transfer was detected. */
 	/*
 	 * Found in $LogFile/$DATA when a page is full of 0xff bytes and is
 	 * thus not initialized.  Page must be initialized before using it.
 	 */
-	magic_empty = const_cpu_to_le32(0xffffffff) /* Record is empty. */
+	magic_empty = cpu_to_le32(0xffffffff) /* Record is empty. */
 };
 
 typedef le32 NTFS_RECORD_TYPE;
@@ -258,8 +247,8 @@ typedef enum {
  * information about the mft record in which they are present.
  */
 enum {
-	MFT_RECORD_IN_USE	= const_cpu_to_le16(0x0001),
-	MFT_RECORD_IS_DIRECTORY = const_cpu_to_le16(0x0002),
+	MFT_RECORD_IN_USE	= cpu_to_le16(0x0001),
+	MFT_RECORD_IS_DIRECTORY = cpu_to_le16(0x0002),
 } __attribute__ ((__packed__));
 
 typedef le16 MFT_RECORD_FLAGS;
@@ -309,7 +298,7 @@ typedef le16 MFT_RECORD_FLAGS;
  * Note: The _LE versions will return a CPU endian formatted value!
  */
 #define MFT_REF_MASK_CPU 0x0000ffffffffffffULL
-#define MFT_REF_MASK_LE const_cpu_to_le64(MFT_REF_MASK_CPU)
+#define MFT_REF_MASK_LE cpu_to_le64(MFT_REF_MASK_CPU)
 
 typedef u64 MFT_REF;
 typedef le64 leMFT_REF;
@@ -477,25 +466,25 @@ typedef struct {
  * a revealing choice of symbol I do not know what is... (-;
  */
 enum {
-	AT_UNUSED			= const_cpu_to_le32(         0),
-	AT_STANDARD_INFORMATION		= const_cpu_to_le32(      0x10),
-	AT_ATTRIBUTE_LIST		= const_cpu_to_le32(      0x20),
-	AT_FILE_NAME			= const_cpu_to_le32(      0x30),
-	AT_OBJECT_ID			= const_cpu_to_le32(      0x40),
-	AT_SECURITY_DESCRIPTOR		= const_cpu_to_le32(      0x50),
-	AT_VOLUME_NAME			= const_cpu_to_le32(      0x60),
-	AT_VOLUME_INFORMATION		= const_cpu_to_le32(      0x70),
-	AT_DATA				= const_cpu_to_le32(      0x80),
-	AT_INDEX_ROOT			= const_cpu_to_le32(      0x90),
-	AT_INDEX_ALLOCATION		= const_cpu_to_le32(      0xa0),
-	AT_BITMAP			= const_cpu_to_le32(      0xb0),
-	AT_REPARSE_POINT		= const_cpu_to_le32(      0xc0),
-	AT_EA_INFORMATION		= const_cpu_to_le32(      0xd0),
-	AT_EA				= const_cpu_to_le32(      0xe0),
-	AT_PROPERTY_SET			= const_cpu_to_le32(      0xf0),
-	AT_LOGGED_UTILITY_STREAM	= const_cpu_to_le32(     0x100),
-	AT_FIRST_USER_DEFINED_ATTRIBUTE	= const_cpu_to_le32(    0x1000),
-	AT_END				= const_cpu_to_le32(0xffffffff)
+	AT_UNUSED			= cpu_to_le32(         0),
+	AT_STANDARD_INFORMATION		= cpu_to_le32(      0x10),
+	AT_ATTRIBUTE_LIST		= cpu_to_le32(      0x20),
+	AT_FILE_NAME			= cpu_to_le32(      0x30),
+	AT_OBJECT_ID			= cpu_to_le32(      0x40),
+	AT_SECURITY_DESCRIPTOR		= cpu_to_le32(      0x50),
+	AT_VOLUME_NAME			= cpu_to_le32(      0x60),
+	AT_VOLUME_INFORMATION		= cpu_to_le32(      0x70),
+	AT_DATA				= cpu_to_le32(      0x80),
+	AT_INDEX_ROOT			= cpu_to_le32(      0x90),
+	AT_INDEX_ALLOCATION		= cpu_to_le32(      0xa0),
+	AT_BITMAP			= cpu_to_le32(      0xb0),
+	AT_REPARSE_POINT		= cpu_to_le32(      0xc0),
+	AT_EA_INFORMATION		= cpu_to_le32(      0xd0),
+	AT_EA				= cpu_to_le32(      0xe0),
+	AT_PROPERTY_SET			= cpu_to_le32(      0xf0),
+	AT_LOGGED_UTILITY_STREAM	= cpu_to_le32(     0x100),
+	AT_FIRST_USER_DEFINED_ATTRIBUTE	= cpu_to_le32(    0x1000),
+	AT_END				= cpu_to_le32(0xffffffff)
 };
 
 typedef le32 ATTR_TYPE;
@@ -539,13 +528,13 @@ typedef le32 ATTR_TYPE;
  *	equal then the second le32 values would be compared, etc.
  */
 enum {
-	COLLATION_BINARY		= const_cpu_to_le32(0x00),
-	COLLATION_FILE_NAME		= const_cpu_to_le32(0x01),
-	COLLATION_UNICODE_STRING	= const_cpu_to_le32(0x02),
-	COLLATION_NTOFS_ULONG		= const_cpu_to_le32(0x10),
-	COLLATION_NTOFS_SID		= const_cpu_to_le32(0x11),
-	COLLATION_NTOFS_SECURITY_HASH	= const_cpu_to_le32(0x12),
-	COLLATION_NTOFS_ULONGS		= const_cpu_to_le32(0x13),
+	COLLATION_BINARY		= cpu_to_le32(0x00),
+	COLLATION_FILE_NAME		= cpu_to_le32(0x01),
+	COLLATION_UNICODE_STRING	= cpu_to_le32(0x02),
+	COLLATION_NTOFS_ULONG		= cpu_to_le32(0x10),
+	COLLATION_NTOFS_SID		= cpu_to_le32(0x11),
+	COLLATION_NTOFS_SECURITY_HASH	= cpu_to_le32(0x12),
+	COLLATION_NTOFS_ULONGS		= cpu_to_le32(0x13),
 };
 
 typedef le32 COLLATION_RULE;
@@ -559,25 +548,25 @@ typedef le32 COLLATION_RULE;
  * NT4.
  */
 enum {
-	ATTR_DEF_INDEXABLE	= const_cpu_to_le32(0x02), /* Attribute can be
+	ATTR_DEF_INDEXABLE	= cpu_to_le32(0x02), /* Attribute can be
 					indexed. */
-	ATTR_DEF_MULTIPLE	= const_cpu_to_le32(0x04), /* Attribute type
+	ATTR_DEF_MULTIPLE	= cpu_to_le32(0x04), /* Attribute type
 					can be present multiple times in the
 					mft records of an inode. */
-	ATTR_DEF_NOT_ZERO	= const_cpu_to_le32(0x08), /* Attribute value
+	ATTR_DEF_NOT_ZERO	= cpu_to_le32(0x08), /* Attribute value
 					must contain at least one non-zero
 					byte. */
-	ATTR_DEF_INDEXED_UNIQUE	= const_cpu_to_le32(0x10), /* Attribute must be
+	ATTR_DEF_INDEXED_UNIQUE	= cpu_to_le32(0x10), /* Attribute must be
 					indexed and the attribute value must be
 					unique for the attribute type in all of
 					the mft records of an inode. */
-	ATTR_DEF_NAMED_UNIQUE	= const_cpu_to_le32(0x20), /* Attribute must be
+	ATTR_DEF_NAMED_UNIQUE	= cpu_to_le32(0x20), /* Attribute must be
 					named and the name must be unique for
 					the attribute type in all of the mft
 					records of an inode. */
-	ATTR_DEF_RESIDENT	= const_cpu_to_le32(0x40), /* Attribute must be
+	ATTR_DEF_RESIDENT	= cpu_to_le32(0x40), /* Attribute must be
 					resident. */
-	ATTR_DEF_ALWAYS_LOG	= const_cpu_to_le32(0x80), /* Always log
+	ATTR_DEF_ALWAYS_LOG	= cpu_to_le32(0x80), /* Always log
 					modifications to this attribute,
 					regardless of whether it is resident or
 					non-resident.  Without this, only log
@@ -614,12 +603,12 @@ typedef struct {
  * Attribute flags (16-bit).
  */
 enum {
-	ATTR_IS_COMPRESSED    = const_cpu_to_le16(0x0001),
-	ATTR_COMPRESSION_MASK = const_cpu_to_le16(0x00ff), /* Compression method
+	ATTR_IS_COMPRESSED    = cpu_to_le16(0x0001),
+	ATTR_COMPRESSION_MASK = cpu_to_le16(0x00ff), /* Compression method
 							      mask.  Also, first
 							      illegal value. */
-	ATTR_IS_ENCRYPTED     = const_cpu_to_le16(0x4000),
-	ATTR_IS_SPARSE	      = const_cpu_to_le16(0x8000),
+	ATTR_IS_ENCRYPTED     = cpu_to_le16(0x4000),
+	ATTR_IS_SPARSE	      = cpu_to_le16(0x8000),
 } __attribute__ ((__packed__));
 
 typedef le16 ATTR_FLAGS;
@@ -811,32 +800,32 @@ typedef ATTR_RECORD ATTR_REC;
  * flags appear in all of the above.
  */
 enum {
-	FILE_ATTR_READONLY		= const_cpu_to_le32(0x00000001),
-	FILE_ATTR_HIDDEN		= const_cpu_to_le32(0x00000002),
-	FILE_ATTR_SYSTEM		= const_cpu_to_le32(0x00000004),
-	/* Old DOS volid. Unused in NT.	= const_cpu_to_le32(0x00000008), */
+	FILE_ATTR_READONLY		= cpu_to_le32(0x00000001),
+	FILE_ATTR_HIDDEN		= cpu_to_le32(0x00000002),
+	FILE_ATTR_SYSTEM		= cpu_to_le32(0x00000004),
+	/* Old DOS volid. Unused in NT.	= cpu_to_le32(0x00000008), */
 
-	FILE_ATTR_DIRECTORY		= const_cpu_to_le32(0x00000010),
+	FILE_ATTR_DIRECTORY		= cpu_to_le32(0x00000010),
 	/* Note, FILE_ATTR_DIRECTORY is not considered valid in NT.  It is
 	   reserved for the DOS SUBDIRECTORY flag. */
-	FILE_ATTR_ARCHIVE		= const_cpu_to_le32(0x00000020),
-	FILE_ATTR_DEVICE		= const_cpu_to_le32(0x00000040),
-	FILE_ATTR_NORMAL		= const_cpu_to_le32(0x00000080),
-
-	FILE_ATTR_TEMPORARY		= const_cpu_to_le32(0x00000100),
-	FILE_ATTR_SPARSE_FILE		= const_cpu_to_le32(0x00000200),
-	FILE_ATTR_REPARSE_POINT		= const_cpu_to_le32(0x00000400),
-	FILE_ATTR_COMPRESSED		= const_cpu_to_le32(0x00000800),
-
-	FILE_ATTR_OFFLINE		= const_cpu_to_le32(0x00001000),
-	FILE_ATTR_NOT_CONTENT_INDEXED	= const_cpu_to_le32(0x00002000),
-	FILE_ATTR_ENCRYPTED		= const_cpu_to_le32(0x00004000),
+	FILE_ATTR_ARCHIVE		= cpu_to_le32(0x00000020),
+	FILE_ATTR_DEVICE		= cpu_to_le32(0x00000040),
+	FILE_ATTR_NORMAL		= cpu_to_le32(0x00000080),
+
+	FILE_ATTR_TEMPORARY		= cpu_to_le32(0x00000100),
+	FILE_ATTR_SPARSE_FILE		= cpu_to_le32(0x00000200),
+	FILE_ATTR_REPARSE_POINT		= cpu_to_le32(0x00000400),
+	FILE_ATTR_COMPRESSED		= cpu_to_le32(0x00000800),
+
+	FILE_ATTR_OFFLINE		= cpu_to_le32(0x00001000),
+	FILE_ATTR_NOT_CONTENT_INDEXED	= cpu_to_le32(0x00002000),
+	FILE_ATTR_ENCRYPTED		= cpu_to_le32(0x00004000),
 
-	FILE_ATTR_VALID_FLAGS		= const_cpu_to_le32(0x00007fb7),
+	FILE_ATTR_VALID_FLAGS		= cpu_to_le32(0x00007fb7),
 	/* Note, FILE_ATTR_VALID_FLAGS masks out the old DOS VolId and the
 	   FILE_ATTR_DEVICE and preserves everything else.  This mask is used
 	   to obtain all flags that are valid for reading. */
-	FILE_ATTR_VALID_SET_FLAGS	= const_cpu_to_le32(0x000031a7),
+	FILE_ATTR_VALID_SET_FLAGS	= cpu_to_le32(0x000031a7),
 	/* Note, FILE_ATTR_VALID_SET_FLAGS masks out the old DOS VolId, the
 	   F_A_DEVICE, F_A_DIRECTORY, F_A_SPARSE_FILE, F_A_REPARSE_POINT,
 	   F_A_COMPRESSED, and F_A_ENCRYPTED and preserves the rest.  This mask
@@ -846,11 +835,11 @@ enum {
 	 * FILENAME_ATTR attributes but not in the STANDARD_INFORMATION
 	 * attribute of an mft record.
 	 */
-	FILE_ATTR_DUP_FILE_NAME_INDEX_PRESENT	= const_cpu_to_le32(0x10000000),
+	FILE_ATTR_DUP_FILE_NAME_INDEX_PRESENT	= cpu_to_le32(0x10000000),
 	/* Note, this is a copy of the corresponding bit from the mft record,
 	   telling us whether this is a directory or not, i.e. whether it has
 	   an index root attribute or not. */
-	FILE_ATTR_DUP_VIEW_INDEX_PRESENT	= const_cpu_to_le32(0x20000000),
+	FILE_ATTR_DUP_VIEW_INDEX_PRESENT	= cpu_to_le32(0x20000000),
 	/* Note, this is a copy of the corresponding bit from the mft record,
 	   telling us whether this file has a view index present (eg. object id
 	   index, quota index, one of the security indexes or the encrypting
@@ -1446,42 +1435,42 @@ enum {
 	/* Specific rights for files and directories are as follows: */
 
 	/* Right to read data from the file. (FILE) */
-	FILE_READ_DATA			= const_cpu_to_le32(0x00000001),
+	FILE_READ_DATA			= cpu_to_le32(0x00000001),
 	/* Right to list contents of a directory. (DIRECTORY) */
-	FILE_LIST_DIRECTORY		= const_cpu_to_le32(0x00000001),
+	FILE_LIST_DIRECTORY		= cpu_to_le32(0x00000001),
 
 	/* Right to write data to the file. (FILE) */
-	FILE_WRITE_DATA			= const_cpu_to_le32(0x00000002),
+	FILE_WRITE_DATA			= cpu_to_le32(0x00000002),
 	/* Right to create a file in the directory. (DIRECTORY) */
-	FILE_ADD_FILE			= const_cpu_to_le32(0x00000002),
+	FILE_ADD_FILE			= cpu_to_le32(0x00000002),
 
 	/* Right to append data to the file. (FILE) */
-	FILE_APPEND_DATA		= const_cpu_to_le32(0x00000004),
+	FILE_APPEND_DATA		= cpu_to_le32(0x00000004),
 	/* Right to create a subdirectory. (DIRECTORY) */
-	FILE_ADD_SUBDIRECTORY		= const_cpu_to_le32(0x00000004),
+	FILE_ADD_SUBDIRECTORY		= cpu_to_le32(0x00000004),
 
 	/* Right to read extended attributes. (FILE/DIRECTORY) */
-	FILE_READ_EA			= const_cpu_to_le32(0x00000008),
+	FILE_READ_EA			= cpu_to_le32(0x00000008),
 
 	/* Right to write extended attributes. (FILE/DIRECTORY) */
-	FILE_WRITE_EA			= const_cpu_to_le32(0x00000010),
+	FILE_WRITE_EA			= cpu_to_le32(0x00000010),
 
 	/* Right to execute a file. (FILE) */
-	FILE_EXECUTE			= const_cpu_to_le32(0x00000020),
+	FILE_EXECUTE			= cpu_to_le32(0x00000020),
 	/* Right to traverse the directory. (DIRECTORY) */
-	FILE_TRAVERSE			= const_cpu_to_le32(0x00000020),
+	FILE_TRAVERSE			= cpu_to_le32(0x00000020),
 
 	/*
 	 * Right to delete a directory and all the files it contains (its
 	 * children), even if the files are read-only. (DIRECTORY)
 	 */
-	FILE_DELETE_CHILD		= const_cpu_to_le32(0x00000040),
+	FILE_DELETE_CHILD		= cpu_to_le32(0x00000040),
 
 	/* Right to read file attributes. (FILE/DIRECTORY) */
-	FILE_READ_ATTRIBUTES		= const_cpu_to_le32(0x00000080),
+	FILE_READ_ATTRIBUTES		= cpu_to_le32(0x00000080),
 
 	/* Right to change file attributes. (FILE/DIRECTORY) */
-	FILE_WRITE_ATTRIBUTES		= const_cpu_to_le32(0x00000100),
+	FILE_WRITE_ATTRIBUTES		= cpu_to_le32(0x00000100),
 
 	/*
 	 * The standard rights (bits 16 to 23).  These are independent of the
@@ -1489,27 +1478,27 @@ enum {
 	 */
 
 	/* Right to delete the object. */
-	DELETE				= const_cpu_to_le32(0x00010000),
+	DELETE				= cpu_to_le32(0x00010000),
 
 	/*
 	 * Right to read the information in the object's security descriptor,
 	 * not including the information in the SACL, i.e. right to read the
 	 * security descriptor and owner.
 	 */
-	READ_CONTROL			= const_cpu_to_le32(0x00020000),
+	READ_CONTROL			= cpu_to_le32(0x00020000),
 
 	/* Right to modify the DACL in the object's security descriptor. */
-	WRITE_DAC			= const_cpu_to_le32(0x00040000),
+	WRITE_DAC			= cpu_to_le32(0x00040000),
 
 	/* Right to change the owner in the object's security descriptor. */
-	WRITE_OWNER			= const_cpu_to_le32(0x00080000),
+	WRITE_OWNER			= cpu_to_le32(0x00080000),
 
 	/*
 	 * Right to use the object for synchronization.  Enables a process to
 	 * wait until the object is in the signalled state.  Some object types
 	 * do not support this access right.
 	 */
-	SYNCHRONIZE			= const_cpu_to_le32(0x00100000),
+	SYNCHRONIZE			= cpu_to_le32(0x00100000),
 
 	/*
 	 * The following STANDARD_RIGHTS_* are combinations of the above for
@@ -1517,25 +1506,25 @@ enum {
 	 */
 
 	/* These are currently defined to READ_CONTROL. */
-	STANDARD_RIGHTS_READ		= const_cpu_to_le32(0x00020000),
-	STANDARD_RIGHTS_WRITE		= const_cpu_to_le32(0x00020000),
-	STANDARD_RIGHTS_EXECUTE		= const_cpu_to_le32(0x00020000),
+	STANDARD_RIGHTS_READ		= cpu_to_le32(0x00020000),
+	STANDARD_RIGHTS_WRITE		= cpu_to_le32(0x00020000),
+	STANDARD_RIGHTS_EXECUTE		= cpu_to_le32(0x00020000),
 
 	/* Combines DELETE, READ_CONTROL, WRITE_DAC, and WRITE_OWNER access. */
-	STANDARD_RIGHTS_REQUIRED	= const_cpu_to_le32(0x000f0000),
+	STANDARD_RIGHTS_REQUIRED	= cpu_to_le32(0x000f0000),
 
 	/*
 	 * Combines DELETE, READ_CONTROL, WRITE_DAC, WRITE_OWNER, and
 	 * SYNCHRONIZE access.
 	 */
-	STANDARD_RIGHTS_ALL		= const_cpu_to_le32(0x001f0000),
+	STANDARD_RIGHTS_ALL		= cpu_to_le32(0x001f0000),
 
 	/*
 	 * The access system ACL and maximum allowed access types (bits 24 to
 	 * 25, bits 26 to 27 are reserved).
 	 */
-	ACCESS_SYSTEM_SECURITY		= const_cpu_to_le32(0x01000000),
-	MAXIMUM_ALLOWED			= const_cpu_to_le32(0x02000000),
+	ACCESS_SYSTEM_SECURITY		= cpu_to_le32(0x01000000),
+	MAXIMUM_ALLOWED			= cpu_to_le32(0x02000000),
 
 	/*
 	 * The generic rights (bits 28 to 31).  These map onto the standard and
@@ -1543,10 +1532,10 @@ enum {
 	 */
 
 	/* Read, write, and execute access. */
-	GENERIC_ALL			= const_cpu_to_le32(0x10000000),
+	GENERIC_ALL			= cpu_to_le32(0x10000000),
 
 	/* Execute access. */
-	GENERIC_EXECUTE			= const_cpu_to_le32(0x20000000),
+	GENERIC_EXECUTE			= cpu_to_le32(0x20000000),
 
 	/*
 	 * Write access.  For files, this maps onto:
@@ -1555,7 +1544,7 @@ enum {
 	 * For directories, the mapping has the same numerical value.  See
 	 * above for the descriptions of the rights granted.
 	 */
-	GENERIC_WRITE			= const_cpu_to_le32(0x40000000),
+	GENERIC_WRITE			= cpu_to_le32(0x40000000),
 
 	/*
 	 * Read access.  For files, this maps onto:
@@ -1564,7 +1553,7 @@ enum {
 	 * For directories, the mapping has the same numberical value.  See
 	 * above for the descriptions of the rights granted.
 	 */
-	GENERIC_READ			= const_cpu_to_le32(0x80000000),
+	GENERIC_READ			= cpu_to_le32(0x80000000),
 };
 
 typedef le32 ACCESS_MASK;
@@ -1604,8 +1593,8 @@ typedef struct {
  * The object ACE flags (32-bit).
  */
 enum {
-	ACE_OBJECT_TYPE_PRESENT			= const_cpu_to_le32(1),
-	ACE_INHERITED_OBJECT_TYPE_PRESENT	= const_cpu_to_le32(2),
+	ACE_OBJECT_TYPE_PRESENT			= cpu_to_le32(1),
+	ACE_INHERITED_OBJECT_TYPE_PRESENT	= cpu_to_le32(2),
 };
 
 typedef le32 OBJECT_ACE_FLAGS;
@@ -1706,23 +1695,23 @@ typedef enum {
  *	expressed as offsets from the beginning of the security descriptor.
  */
 enum {
-	SE_OWNER_DEFAULTED		= const_cpu_to_le16(0x0001),
-	SE_GROUP_DEFAULTED		= const_cpu_to_le16(0x0002),
-	SE_DACL_PRESENT			= const_cpu_to_le16(0x0004),
-	SE_DACL_DEFAULTED		= const_cpu_to_le16(0x0008),
-
-	SE_SACL_PRESENT			= const_cpu_to_le16(0x0010),
-	SE_SACL_DEFAULTED		= const_cpu_to_le16(0x0020),
-
-	SE_DACL_AUTO_INHERIT_REQ	= const_cpu_to_le16(0x0100),
-	SE_SACL_AUTO_INHERIT_REQ	= const_cpu_to_le16(0x0200),
-	SE_DACL_AUTO_INHERITED		= const_cpu_to_le16(0x0400),
-	SE_SACL_AUTO_INHERITED		= const_cpu_to_le16(0x0800),
-
-	SE_DACL_PROTECTED		= const_cpu_to_le16(0x1000),
-	SE_SACL_PROTECTED		= const_cpu_to_le16(0x2000),
-	SE_RM_CONTROL_VALID		= const_cpu_to_le16(0x4000),
-	SE_SELF_RELATIVE		= const_cpu_to_le16(0x8000)
+	SE_OWNER_DEFAULTED		= cpu_to_le16(0x0001),
+	SE_GROUP_DEFAULTED		= cpu_to_le16(0x0002),
+	SE_DACL_PRESENT			= cpu_to_le16(0x0004),
+	SE_DACL_DEFAULTED		= cpu_to_le16(0x0008),
+
+	SE_SACL_PRESENT			= cpu_to_le16(0x0010),
+	SE_SACL_DEFAULTED		= cpu_to_le16(0x0020),
+
+	SE_DACL_AUTO_INHERIT_REQ	= cpu_to_le16(0x0100),
+	SE_SACL_AUTO_INHERIT_REQ	= cpu_to_le16(0x0200),
+	SE_DACL_AUTO_INHERITED		= cpu_to_le16(0x0400),
+	SE_SACL_AUTO_INHERITED		= cpu_to_le16(0x0800),
+
+	SE_DACL_PROTECTED		= cpu_to_le16(0x1000),
+	SE_SACL_PROTECTED		= cpu_to_le16(0x2000),
+	SE_RM_CONTROL_VALID		= cpu_to_le16(0x4000),
+	SE_SELF_RELATIVE		= cpu_to_le16(0x8000)
 } __attribute__ ((__packed__));
 
 typedef le16 SECURITY_DESCRIPTOR_CONTROL;
@@ -1910,21 +1899,21 @@ typedef struct {
  * Possible flags for the volume (16-bit).
  */
 enum {
-	VOLUME_IS_DIRTY			= const_cpu_to_le16(0x0001),
-	VOLUME_RESIZE_LOG_FILE		= const_cpu_to_le16(0x0002),
-	VOLUME_UPGRADE_ON_MOUNT		= const_cpu_to_le16(0x0004),
-	VOLUME_MOUNTED_ON_NT4		= const_cpu_to_le16(0x0008),
+	VOLUME_IS_DIRTY			= cpu_to_le16(0x0001),
+	VOLUME_RESIZE_LOG_FILE		= cpu_to_le16(0x0002),
+	VOLUME_UPGRADE_ON_MOUNT		= cpu_to_le16(0x0004),
+	VOLUME_MOUNTED_ON_NT4		= cpu_to_le16(0x0008),
 
-	VOLUME_DELETE_USN_UNDERWAY	= const_cpu_to_le16(0x0010),
-	VOLUME_REPAIR_OBJECT_ID		= const_cpu_to_le16(0x0020),
+	VOLUME_DELETE_USN_UNDERWAY	= cpu_to_le16(0x0010),
+	VOLUME_REPAIR_OBJECT_ID		= cpu_to_le16(0x0020),
 
-	VOLUME_CHKDSK_UNDERWAY		= const_cpu_to_le16(0x4000),
-	VOLUME_MODIFIED_BY_CHKDSK	= const_cpu_to_le16(0x8000),
+	VOLUME_CHKDSK_UNDERWAY		= cpu_to_le16(0x4000),
+	VOLUME_MODIFIED_BY_CHKDSK	= cpu_to_le16(0x8000),
 
-	VOLUME_FLAGS_MASK		= const_cpu_to_le16(0xc03f),
+	VOLUME_FLAGS_MASK		= cpu_to_le16(0xc03f),
 
 	/* To make our life easier when checking if we must mount read-only. */
-	VOLUME_MUST_MOUNT_RO_MASK	= const_cpu_to_le16(0xc027),
+	VOLUME_MUST_MOUNT_RO_MASK	= cpu_to_le16(0xc027),
 } __attribute__ ((__packed__));
 
 typedef le16 VOLUME_FLAGS;
@@ -2109,26 +2098,26 @@ typedef struct {
  * The user quota flags.  Names explain meaning.
  */
 enum {
-	QUOTA_FLAG_DEFAULT_LIMITS	= const_cpu_to_le32(0x00000001),
-	QUOTA_FLAG_LIMIT_REACHED	= const_cpu_to_le32(0x00000002),
-	QUOTA_FLAG_ID_DELETED		= const_cpu_to_le32(0x00000004),
+	QUOTA_FLAG_DEFAULT_LIMITS	= cpu_to_le32(0x00000001),
+	QUOTA_FLAG_LIMIT_REACHED	= cpu_to_le32(0x00000002),
+	QUOTA_FLAG_ID_DELETED		= cpu_to_le32(0x00000004),
 
-	QUOTA_FLAG_USER_MASK		= const_cpu_to_le32(0x00000007),
+	QUOTA_FLAG_USER_MASK		= cpu_to_le32(0x00000007),
 	/* This is a bit mask for the user quota flags. */
 
 	/*
 	 * These flags are only present in the quota defaults index entry, i.e.
 	 * in the entry where owner_id = QUOTA_DEFAULTS_ID.
 	 */
-	QUOTA_FLAG_TRACKING_ENABLED	= const_cpu_to_le32(0x00000010),
-	QUOTA_FLAG_ENFORCEMENT_ENABLED	= const_cpu_to_le32(0x00000020),
-	QUOTA_FLAG_TRACKING_REQUESTED	= const_cpu_to_le32(0x00000040),
-	QUOTA_FLAG_LOG_THRESHOLD	= const_cpu_to_le32(0x00000080),
-
-	QUOTA_FLAG_LOG_LIMIT		= const_cpu_to_le32(0x00000100),
-	QUOTA_FLAG_OUT_OF_DATE		= const_cpu_to_le32(0x00000200),
-	QUOTA_FLAG_CORRUPT		= const_cpu_to_le32(0x00000400),
-	QUOTA_FLAG_PENDING_DELETES	= const_cpu_to_le32(0x00000800),
+	QUOTA_FLAG_TRACKING_ENABLED	= cpu_to_le32(0x00000010),
+	QUOTA_FLAG_ENFORCEMENT_ENABLED	= cpu_to_le32(0x00000020),
+	QUOTA_FLAG_TRACKING_REQUESTED	= cpu_to_le32(0x00000040),
+	QUOTA_FLAG_LOG_THRESHOLD	= cpu_to_le32(0x00000080),
+
+	QUOTA_FLAG_LOG_LIMIT		= cpu_to_le32(0x00000100),
+	QUOTA_FLAG_OUT_OF_DATE		= cpu_to_le32(0x00000200),
+	QUOTA_FLAG_CORRUPT		= cpu_to_le32(0x00000400),
+	QUOTA_FLAG_PENDING_DELETES	= cpu_to_le32(0x00000800),
 };
 
 typedef le32 QUOTA_FLAGS;
@@ -2172,9 +2161,9 @@ typedef struct {
  * Predefined owner_id values (32-bit).
  */
 enum {
-	QUOTA_INVALID_ID	= const_cpu_to_le32(0x00000000),
-	QUOTA_DEFAULTS_ID	= const_cpu_to_le32(0x00000001),
-	QUOTA_FIRST_USER_ID	= const_cpu_to_le32(0x00000100),
+	QUOTA_INVALID_ID	= cpu_to_le32(0x00000000),
+	QUOTA_DEFAULTS_ID	= cpu_to_le32(0x00000001),
+	QUOTA_FIRST_USER_ID	= cpu_to_le32(0x00000100),
 };
 
 /*
@@ -2189,14 +2178,14 @@ typedef enum {
  * Index entry flags (16-bit).
  */
 enum {
-	INDEX_ENTRY_NODE = const_cpu_to_le16(1), /* This entry contains a
+	INDEX_ENTRY_NODE = cpu_to_le16(1), /* This entry contains a
 			sub-node, i.e. a reference to an index block in form of
 			a virtual cluster number (see below). */
-	INDEX_ENTRY_END  = const_cpu_to_le16(2), /* This signifies the last
+	INDEX_ENTRY_END  = cpu_to_le16(2), /* This signifies the last
 			entry in an index block.  The index entry does not
 			represent a file but it can point to a sub-node. */
 
-	INDEX_ENTRY_SPACE_FILLER = const_cpu_to_le16(0xffff), /* gcc: Force
+	INDEX_ENTRY_SPACE_FILLER = cpu_to_le16(0xffff), /* gcc: Force
 			enum bit width to 16-bit. */
 } __attribute__ ((__packed__));
 
@@ -2334,26 +2323,26 @@ typedef struct {
  * These are the predefined reparse point tags:
  */
 enum {
-	IO_REPARSE_TAG_IS_ALIAS		= const_cpu_to_le32(0x20000000),
-	IO_REPARSE_TAG_IS_HIGH_LATENCY	= const_cpu_to_le32(0x40000000),
-	IO_REPARSE_TAG_IS_MICROSOFT	= const_cpu_to_le32(0x80000000),
+	IO_REPARSE_TAG_IS_ALIAS		= cpu_to_le32(0x20000000),
+	IO_REPARSE_TAG_IS_HIGH_LATENCY	= cpu_to_le32(0x40000000),
+	IO_REPARSE_TAG_IS_MICROSOFT	= cpu_to_le32(0x80000000),
 
-	IO_REPARSE_TAG_RESERVED_ZERO	= const_cpu_to_le32(0x00000000),
-	IO_REPARSE_TAG_RESERVED_ONE	= const_cpu_to_le32(0x00000001),
-	IO_REPARSE_TAG_RESERVED_RANGE	= const_cpu_to_le32(0x00000001),
+	IO_REPARSE_TAG_RESERVED_ZERO	= cpu_to_le32(0x00000000),
+	IO_REPARSE_TAG_RESERVED_ONE	= cpu_to_le32(0x00000001),
+	IO_REPARSE_TAG_RESERVED_RANGE	= cpu_to_le32(0x00000001),
 
-	IO_REPARSE_TAG_NSS		= const_cpu_to_le32(0x68000005),
-	IO_REPARSE_TAG_NSS_RECOVER	= const_cpu_to_le32(0x68000006),
-	IO_REPARSE_TAG_SIS		= const_cpu_to_le32(0x68000007),
-	IO_REPARSE_TAG_DFS		= const_cpu_to_le32(0x68000008),
+	IO_REPARSE_TAG_NSS		= cpu_to_le32(0x68000005),
+	IO_REPARSE_TAG_NSS_RECOVER	= cpu_to_le32(0x68000006),
+	IO_REPARSE_TAG_SIS		= cpu_to_le32(0x68000007),
+	IO_REPARSE_TAG_DFS		= cpu_to_le32(0x68000008),
 
-	IO_REPARSE_TAG_MOUNT_POINT	= const_cpu_to_le32(0x88000003),
+	IO_REPARSE_TAG_MOUNT_POINT	= cpu_to_le32(0x88000003),
 
-	IO_REPARSE_TAG_HSM		= const_cpu_to_le32(0xa8000004),
+	IO_REPARSE_TAG_HSM		= cpu_to_le32(0xa8000004),
 
-	IO_REPARSE_TAG_SYMBOLIC_LINK	= const_cpu_to_le32(0xe8000000),
+	IO_REPARSE_TAG_SYMBOLIC_LINK	= cpu_to_le32(0xe8000000),
 
-	IO_REPARSE_TAG_VALID_VALUES	= const_cpu_to_le32(0xe000ffff),
+	IO_REPARSE_TAG_VALID_VALUES	= cpu_to_le32(0xe000ffff),
 };
 
 /*
diff -puN fs/ntfs/logfile.h~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/logfile.h
--- a/fs/ntfs/logfile.h~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/logfile.h
@@ -104,7 +104,7 @@ typedef struct {
  * in this particular client array.  Also inside the client records themselves,
  * this means that there are no client records preceding or following this one.
  */
-#define LOGFILE_NO_CLIENT	const_cpu_to_le16(0xffff)
+#define LOGFILE_NO_CLIENT	cpu_to_le16(0xffff)
 #define LOGFILE_NO_CLIENT_CPU	0xffff
 
 /*
@@ -112,8 +112,8 @@ typedef struct {
  * information about the log file in which they are present.
  */
 enum {
-	RESTART_VOLUME_IS_CLEAN	= const_cpu_to_le16(0x0002),
-	RESTART_SPACE_FILLER	= const_cpu_to_le16(0xffff), /* gcc: Force enum bit width to 16. */
+	RESTART_VOLUME_IS_CLEAN	= cpu_to_le16(0x0002),
+	RESTART_SPACE_FILLER	= cpu_to_le16(0xffff), /* gcc: Force enum bit width to 16. */
 } __attribute__ ((__packed__));
 
 typedef le16 RESTART_AREA_FLAGS;
diff -puN fs/ntfs/mft.c~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/mft.c
--- a/fs/ntfs/mft.c~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/mft.c
@@ -2839,7 +2839,7 @@ int ntfs_extent_mft_record_free(ntfs_ino
 	 */
 
 	/* Mark the mft record as not in use. */
-	m->flags &= const_cpu_to_le16(~const_le16_to_cpu(MFT_RECORD_IN_USE));
+	m->flags &= ~MFT_RECORD_IN_USE;
 
 	/* Increment the sequence number, skipping zero, if it is not zero. */
 	old_seq_no = m->sequence_number;
diff -puN fs/ntfs/super.c~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/super.c
--- a/fs/ntfs/super.c~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/super.c
@@ -618,7 +618,7 @@ static bool is_boot_sector_ntfs(const st
 	 * many BIOSes will refuse to boot from a bootsector if the magic is
 	 * incorrect, so we emit a warning.
 	 */
-	if (!silent && b->end_of_sector_marker != const_cpu_to_le16(0xaa55))
+	if (!silent && b->end_of_sector_marker != cpu_to_le16(0xaa55))
 		ntfs_warning(sb, "Invalid end of sector marker.");
 	return true;
 not_ntfs:
@@ -1242,13 +1242,13 @@ static int check_windows_hibernation_sta
 	u32 *kaddr, *kend;
 	ntfs_name *name = NULL;
 	int ret = 1;
-	static const ntfschar hiberfil[13] = { const_cpu_to_le16('h'),
-			const_cpu_to_le16('i'), const_cpu_to_le16('b'),
-			const_cpu_to_le16('e'), const_cpu_to_le16('r'),
-			const_cpu_to_le16('f'), const_cpu_to_le16('i'),
-			const_cpu_to_le16('l'), const_cpu_to_le16('.'),
-			const_cpu_to_le16('s'), const_cpu_to_le16('y'),
-			const_cpu_to_le16('s'), 0 };
+	static const ntfschar hiberfil[13] = { cpu_to_le16('h'),
+			cpu_to_le16('i'), cpu_to_le16('b'),
+			cpu_to_le16('e'), cpu_to_le16('r'),
+			cpu_to_le16('f'), cpu_to_le16('i'),
+			cpu_to_le16('l'), cpu_to_le16('.'),
+			cpu_to_le16('s'), cpu_to_le16('y'),
+			cpu_to_le16('s'), 0 };
 
 	ntfs_debug("Entering.");
 	/*
@@ -1296,7 +1296,7 @@ static int check_windows_hibernation_sta
 		goto iput_out;
 	}
 	kaddr = (u32*)page_address(page);
-	if (*(le32*)kaddr == const_cpu_to_le32(0x72626968)/*'hibr'*/) {
+	if (*(le32*)kaddr == cpu_to_le32(0x72626968)/*'hibr'*/) {
 		ntfs_debug("Magic \"hibr\" found in hiberfil.sys.  Windows is "
 				"hibernated on the volume.  This is the "
 				"system volume.");
@@ -1337,12 +1337,12 @@ static bool load_and_init_quota(ntfs_vol
 	MFT_REF mref;
 	struct inode *tmp_ino;
 	ntfs_name *name = NULL;
-	static const ntfschar Quota[7] = { const_cpu_to_le16('$'),
-			const_cpu_to_le16('Q'), const_cpu_to_le16('u'),
-			const_cpu_to_le16('o'), const_cpu_to_le16('t'),
-			const_cpu_to_le16('a'), 0 };
-	static ntfschar Q[3] = { const_cpu_to_le16('$'),
-			const_cpu_to_le16('Q'), 0 };
+	static const ntfschar Quota[7] = { cpu_to_le16('$'),
+			cpu_to_le16('Q'), cpu_to_le16('u'),
+			cpu_to_le16('o'), cpu_to_le16('t'),
+			cpu_to_le16('a'), 0 };
+	static ntfschar Q[3] = { cpu_to_le16('$'),
+			cpu_to_le16('Q'), 0 };
 
 	ntfs_debug("Entering.");
 	/*
@@ -1416,16 +1416,16 @@ static bool load_and_init_usnjrnl(ntfs_v
 	struct page *page;
 	ntfs_name *name = NULL;
 	USN_HEADER *uh;
-	static const ntfschar UsnJrnl[9] = { const_cpu_to_le16('$'),
-			const_cpu_to_le16('U'), const_cpu_to_le16('s'),
-			const_cpu_to_le16('n'), const_cpu_to_le16('J'),
-			const_cpu_to_le16('r'), const_cpu_to_le16('n'),
-			const_cpu_to_le16('l'), 0 };
-	static ntfschar Max[5] = { const_cpu_to_le16('$'),
-			const_cpu_to_le16('M'), const_cpu_to_le16('a'),
-			const_cpu_to_le16('x'), 0 };
-	static ntfschar J[3] = { const_cpu_to_le16('$'),
-			const_cpu_to_le16('J'), 0 };
+	static const ntfschar UsnJrnl[9] = { cpu_to_le16('$'),
+			cpu_to_le16('U'), cpu_to_le16('s'),
+			cpu_to_le16('n'), cpu_to_le16('J'),
+			cpu_to_le16('r'), cpu_to_le16('n'),
+			cpu_to_le16('l'), 0 };
+	static ntfschar Max[5] = { cpu_to_le16('$'),
+			cpu_to_le16('M'), cpu_to_le16('a'),
+			cpu_to_le16('x'), 0 };
+	static ntfschar J[3] = { cpu_to_le16('$'),
+			cpu_to_le16('J'), 0 };
 
 	ntfs_debug("Entering.");
 	/*
diff -puN fs/ntfs/usnjrnl.h~ntfs-remove-private-wrapper-of-endian-helpers fs/ntfs/usnjrnl.h
--- a/fs/ntfs/usnjrnl.h~ntfs-remove-private-wrapper-of-endian-helpers
+++ a/fs/ntfs/usnjrnl.h
@@ -116,27 +116,27 @@ typedef struct {
  * documentation: http://www.linux-ntfs.org/
  */
 enum {
-	USN_REASON_DATA_OVERWRITE	= const_cpu_to_le32(0x00000001),
-	USN_REASON_DATA_EXTEND		= const_cpu_to_le32(0x00000002),
-	USN_REASON_DATA_TRUNCATION	= const_cpu_to_le32(0x00000004),
-	USN_REASON_NAMED_DATA_OVERWRITE	= const_cpu_to_le32(0x00000010),
-	USN_REASON_NAMED_DATA_EXTEND	= const_cpu_to_le32(0x00000020),
-	USN_REASON_NAMED_DATA_TRUNCATION= const_cpu_to_le32(0x00000040),
-	USN_REASON_FILE_CREATE		= const_cpu_to_le32(0x00000100),
-	USN_REASON_FILE_DELETE		= const_cpu_to_le32(0x00000200),
-	USN_REASON_EA_CHANGE		= const_cpu_to_le32(0x00000400),
-	USN_REASON_SECURITY_CHANGE	= const_cpu_to_le32(0x00000800),
-	USN_REASON_RENAME_OLD_NAME	= const_cpu_to_le32(0x00001000),
-	USN_REASON_RENAME_NEW_NAME	= const_cpu_to_le32(0x00002000),
-	USN_REASON_INDEXABLE_CHANGE	= const_cpu_to_le32(0x00004000),
-	USN_REASON_BASIC_INFO_CHANGE	= const_cpu_to_le32(0x00008000),
-	USN_REASON_HARD_LINK_CHANGE	= const_cpu_to_le32(0x00010000),
-	USN_REASON_COMPRESSION_CHANGE	= const_cpu_to_le32(0x00020000),
-	USN_REASON_ENCRYPTION_CHANGE	= const_cpu_to_le32(0x00040000),
-	USN_REASON_OBJECT_ID_CHANGE	= const_cpu_to_le32(0x00080000),
-	USN_REASON_REPARSE_POINT_CHANGE	= const_cpu_to_le32(0x00100000),
-	USN_REASON_STREAM_CHANGE	= const_cpu_to_le32(0x00200000),
-	USN_REASON_CLOSE		= const_cpu_to_le32(0x80000000),
+	USN_REASON_DATA_OVERWRITE	= cpu_to_le32(0x00000001),
+	USN_REASON_DATA_EXTEND		= cpu_to_le32(0x00000002),
+	USN_REASON_DATA_TRUNCATION	= cpu_to_le32(0x00000004),
+	USN_REASON_NAMED_DATA_OVERWRITE	= cpu_to_le32(0x00000010),
+	USN_REASON_NAMED_DATA_EXTEND	= cpu_to_le32(0x00000020),
+	USN_REASON_NAMED_DATA_TRUNCATION= cpu_to_le32(0x00000040),
+	USN_REASON_FILE_CREATE		= cpu_to_le32(0x00000100),
+	USN_REASON_FILE_DELETE		= cpu_to_le32(0x00000200),
+	USN_REASON_EA_CHANGE		= cpu_to_le32(0x00000400),
+	USN_REASON_SECURITY_CHANGE	= cpu_to_le32(0x00000800),
+	USN_REASON_RENAME_OLD_NAME	= cpu_to_le32(0x00001000),
+	USN_REASON_RENAME_NEW_NAME	= cpu_to_le32(0x00002000),
+	USN_REASON_INDEXABLE_CHANGE	= cpu_to_le32(0x00004000),
+	USN_REASON_BASIC_INFO_CHANGE	= cpu_to_le32(0x00008000),
+	USN_REASON_HARD_LINK_CHANGE	= cpu_to_le32(0x00010000),
+	USN_REASON_COMPRESSION_CHANGE	= cpu_to_le32(0x00020000),
+	USN_REASON_ENCRYPTION_CHANGE	= cpu_to_le32(0x00040000),
+	USN_REASON_OBJECT_ID_CHANGE	= cpu_to_le32(0x00080000),
+	USN_REASON_REPARSE_POINT_CHANGE	= cpu_to_le32(0x00100000),
+	USN_REASON_STREAM_CHANGE	= cpu_to_le32(0x00200000),
+	USN_REASON_CLOSE		= cpu_to_le32(0x80000000),
 };
 
 typedef le32 USN_REASON_FLAGS;
@@ -148,9 +148,9 @@ typedef le32 USN_REASON_FLAGS;
  *	http://www.linux-ntfs.org/
  */
 enum {
-	USN_SOURCE_DATA_MANAGEMENT	  = const_cpu_to_le32(0x00000001),
-	USN_SOURCE_AUXILIARY_DATA	  = const_cpu_to_le32(0x00000002),
-	USN_SOURCE_REPLICATION_MANAGEMENT = const_cpu_to_le32(0x00000004),
+	USN_SOURCE_DATA_MANAGEMENT	  = cpu_to_le32(0x00000001),
+	USN_SOURCE_AUXILIARY_DATA	  = cpu_to_le32(0x00000002),
+	USN_SOURCE_REPLICATION_MANAGEMENT = cpu_to_le32(0x00000004),
 };
 
 typedef le32 USN_SOURCE_INFO_FLAGS;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch

