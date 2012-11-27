From: akpm@linux-foundation.org
Subject: [to-be-updated] hfsplus-code-style-fixes-reworked-support-of-extended-attributes.patch removed from -mm tree
Date: Mon, 26 Nov 2012 16:45:23 -0800
Message-ID: <20121127004524.0DD8320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:49067 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584Ab2K0ApZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 19:45:25 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so355189wey.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 16:45:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava@dubeyko.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: code style fixes - reworked support of extended attributes
has been removed from the -mm tree.  Its filename was
     hfsplus-code-style-fixes-reworked-support-of-extended-attributes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: hfsplus: code style fixes - reworked support of extended attributes

This patch fixes code style issues:
1. Rephrase comment.
2. Fix multiline comment style.
3. The hfsplus_alloc_attr_entry() was corrected.
4. The hfsplus_unistr and hfsplus_attr_unistr structures were declared
   independently.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/attributes.c  |   47 ++++++++++++++++++++++---------------
 fs/hfsplus/hfsplus_raw.h |   22 +++++++++--------
 2 files changed, 41 insertions(+), 28 deletions(-)

diff -puN fs/hfsplus/attributes.c~hfsplus-code-style-fixes-reworked-support-of-extended-attributes fs/hfsplus/attributes.c
--- a/fs/hfsplus/attributes.c~hfsplus-code-style-fixes-reworked-support-of-extended-attributes
+++ a/fs/hfsplus/attributes.c
@@ -67,10 +67,14 @@ int hfsplus_attr_build_key(struct super_
 		key->attr.key_name.length = 0;
 		len = 0;
 	}
-	/* The key_length (be16) doesn't summed in the lenght of whole key.
-	   But the length of the string (be16) should be included in sum.
-	   So, offsetof(hfsplus_attr_key, key_name) is a trick that give
-	   right value. */
+
+	/* The length of the key, as stored in key_len field, does not include
+	 * the size of the key_len field itself.
+	 * So, offsetof(hfsplus_attr_key, key_name) is a trick because
+	 * it takes into consideration key_len field (__be16) of
+	 * hfsplus_attr_key structure instead of length field (__be16) of
+	 * hfsplus_attr_unistr structure.
+	 */
 	key->key_len =
 		cpu_to_be16(offsetof(struct hfsplus_attr_key, key_name) +
 				2 * len);
@@ -90,10 +94,14 @@ void hfsplus_attr_build_key_uni(hfsplus_
 	key->attr.key_name.length = cpu_to_be16(ustrlen);
 	ustrlen *= 2;
 	memcpy(key->attr.key_name.unicode, name->unicode, ustrlen);
-	/* The key_length (be16) doesn't summed in the lenght of whole key.
-	   But the length of the string (be16) should be included in sum.
-	   So, offsetof(hfsplus_attr_key, key_name) is a trick that give
-	   right value. */
+
+	/* The length of the key, as stored in key_len field, does not include
+	 * the size of the key_len field itself.
+	 * So, offsetof(hfsplus_attr_key, key_name) is a trick because
+	 * it takes into consideration key_len field (__be16) of
+	 * hfsplus_attr_key structure instead of length field (__be16) of
+	 * hfsplus_attr_unistr structure.
+	 */
 	key->key_len =
 		cpu_to_be16(offsetof(struct hfsplus_attr_key, key_name) +
 				ustrlen);
@@ -101,10 +109,7 @@ void hfsplus_attr_build_key_uni(hfsplus_
 
 hfsplus_attr_entry *hfsplus_alloc_attr_entry(void)
 {
-	hfsplus_attr_entry *entry;
-	entry = kmem_cache_alloc(hfsplus_attr_tree_cachep, GFP_KERNEL);
-
-	return (entry) ? entry : NULL;
+	return kmem_cache_alloc(hfsplus_attr_tree_cachep, GFP_KERNEL);
 }
 
 void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry)
@@ -119,13 +124,17 @@ static int hfsplus_attr_build_record(hfs
 				u32 cnid, const void *value, size_t size)
 {
 	if (record_type == HFSPLUS_ATTR_FORK_DATA) {
-		/* Mac OS X supports only inline data attributes.
-		   Do nothing. */
+		/*
+		 * Mac OS X supports only inline data attributes.
+		 * Do nothing
+		 */
 		memset(entry, 0, sizeof(*entry));
 		return sizeof(struct hfsplus_attr_fork_data);
 	} else if (record_type == HFSPLUS_ATTR_EXTENTS) {
-		/* Mac OS X supports only inline data attributes.
-		   Do nothing. */
+		/*
+		 * Mac OS X supports only inline data attributes.
+		 * Do nothing.
+		 */
 		memset(entry, 0, sizeof(*entry));
 		return sizeof(struct hfsplus_attr_extents);
 	} else if (record_type == HFSPLUS_ATTR_INLINE_DATA) {
@@ -139,8 +148,10 @@ static int hfsplus_attr_build_record(hfs
 			return HFSPLUS_INVALID_ATTR_RECORD;
 		entry->inline_data.length = cpu_to_be16(len);
 		memcpy(entry->inline_data.raw_bytes, value, len);
-		/* Align len on two-byte boundary.
-		   It needs to add pad byte if we have odd len. */
+		/*
+		 * Align len on two-byte boundary.
+		 * It needs to add pad byte if we have odd len.
+		 */
 		len = round_up(len, 2);
 		return offsetof(struct hfsplus_attr_inline_data, raw_bytes) +
 					len;
diff -puN fs/hfsplus/hfsplus_raw.h~hfsplus-code-style-fixes-reworked-support-of-extended-attributes fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~hfsplus-code-style-fixes-reworked-support-of-extended-attributes
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -55,18 +55,20 @@ typedef __be16 hfsplus_unichr;
 #define HFSPLUS_MAX_STRLEN 255
 #define HFSPLUS_ATTR_MAX_STRLEN 127
 
-#define HFSPLUS_STRING(name, max_len)		\
-struct hfsplus_##name {				\
-	__be16 length;				\
-	hfsplus_unichr unicode[max_len];	\
-} __packed;					\
-
 /* A "string" as used in filenames, etc. */
-HFSPLUS_STRING(unistr, HFSPLUS_MAX_STRLEN)
+struct hfsplus_unistr {
+	__be16 length;
+	hfsplus_unichr unicode[HFSPLUS_MAX_STRLEN];
+} __packed;
 
-/* A "string" is used in attributes file
-   for name of extended attribute */
-HFSPLUS_STRING(attr_unistr, HFSPLUS_ATTR_MAX_STRLEN)
+/*
+ * A "string" is used in attributes file
+ * for name of extended attribute
+ */
+struct hfsplus_attr_unistr {
+	__be16 length;
+	hfsplus_unichr unicode[HFSPLUS_ATTR_MAX_STRLEN];
+} __packed;
 
 /* POSIX permissions */
 struct hfsplus_perm {
_

Patches currently in -mm which might be from slava@dubeyko.com are

hfsplus-avoid-crash-on-failed-block-map-free.patch

