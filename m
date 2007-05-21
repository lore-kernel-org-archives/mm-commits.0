From: akpm@linux-foundation.org
Subject: - add-kstrndup.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:44 -0700
Message-ID: <200705212317.l4LNHhtt022504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35740 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765336AbXEUXYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:24:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, acme@mandriva.com, akinobu.mita@gmail.com, chrisw@sous-sol.org, jeremy@xensource.com, randy.dunlap@oracle.com, takis@issaris.org, viro@ftp.linux.org.uk, yoshfuji@linux-ipv6.org, mm-commits@vger.kernel.org


The patch titled
     add kstrndup
has been removed from the -mm tree.  Its filename was
     add-kstrndup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add kstrndup
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add a kstrndup function, modelled on strndup.  Like strndup this returns a
string copied into its own allocated memory, but it copies no more than the
specified number of bytes from the source.

Remove private strndup() from irda code.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Panagiotis Issaris <takis@issaris.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h  |    1 
 mm/util.c               |   30 +++++++++++++++++++++++---
 net/irda/irias_object.c |   43 ++++----------------------------------
 3 files changed, 33 insertions(+), 41 deletions(-)

diff -puN include/linux/string.h~add-kstrndup include/linux/string.h
--- a/include/linux/string.h~add-kstrndup
+++ a/include/linux/string.h
@@ -105,6 +105,7 @@ extern void * memchr(const void *,int,__
 #endif
 
 extern char *kstrdup(const char *s, gfp_t gfp);
+extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
 #ifdef __cplusplus
diff -puN mm/util.c~add-kstrndup mm/util.c
--- a/mm/util.c~add-kstrndup
+++ a/mm/util.c
@@ -18,9 +18,8 @@ void *__kzalloc(size_t size, gfp_t flags
 }
 EXPORT_SYMBOL(__kzalloc);
 
-/*
+/**
  * kstrdup - allocate space for and copy an existing string
- *
  * @s: the string to duplicate
  * @gfp: the GFP mask used in the kmalloc() call when allocating memory
  */
@@ -41,6 +40,32 @@ char *kstrdup(const char *s, gfp_t gfp)
 EXPORT_SYMBOL(kstrdup);
 
 /**
+ * kstrndup - allocate space for and copy an existing string
+ * @s: the string to duplicate
+ * @max: read at most @max chars from @s
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ */
+char *kstrndup(const char *s, size_t max, gfp_t gfp)
+{
+	size_t len;
+	char *buf;
+
+	if (!s)
+		return NULL;
+
+	len = strlen(s);
+	if (len > max)
+		len = max;
+	buf = kmalloc_track_caller(len+1, gfp);
+ 	if (buf) {
+		memcpy(buf, s, len);
+		buf[len] = '\0';
+	}
+	return buf;
+}
+EXPORT_SYMBOL(kstrndup);
+
+/**
  * kmemdup - duplicate region of memory
  *
  * @src: memory region to duplicate
@@ -60,7 +85,6 @@ EXPORT_SYMBOL(kmemdup);
 
 /*
  * strndup_user - duplicate an existing string from user space
- *
  * @s: The string to duplicate
  * @n: Maximum number of bytes to copy, including the trailing NUL.
  */
diff -puN net/irda/irias_object.c~add-kstrndup net/irda/irias_object.c
--- a/net/irda/irias_object.c~add-kstrndup
+++ a/net/irda/irias_object.c
@@ -36,39 +36,6 @@ hashbin_t *irias_objects;
  */
 struct ias_value irias_missing = { IAS_MISSING, 0, 0, 0, {0}};
 
-/*
- * Function strndup (str, max)
- *
- *    My own kernel version of strndup!
- *
- * Faster, check boundary... Jean II
- */
-static char *strndup(char *str, size_t max)
-{
-	char *new_str;
-	int len;
-
-	/* Check string */
-	if (str == NULL)
-		return NULL;
-	/* Check length, truncate */
-	len = strlen(str);
-	if(len > max)
-		len = max;
-
-	/* Allocate new string */
-	new_str = kmalloc(len + 1, GFP_ATOMIC);
-	if (new_str == NULL) {
-		IRDA_WARNING("%s: Unable to kmalloc!\n", __FUNCTION__);
-		return NULL;
-	}
-
-	/* Copy and truncate */
-	memcpy(new_str, str, len);
-	new_str[len] = '\0';
-
-	return new_str;
-}
 
 /*
  * Function ias_new_object (name, id)
@@ -90,7 +57,7 @@ struct ias_object *irias_new_object( cha
 	}
 
 	obj->magic = IAS_OBJECT_MAGIC;
-	obj->name = strndup(name, IAS_MAX_CLASSNAME);
+	obj->name = kstrndup(name, IAS_MAX_CLASSNAME, GFP_ATOMIC);
 	if (!obj->name) {
 		IRDA_WARNING("%s(), Unable to allocate name!\n",
 			     __FUNCTION__);
@@ -360,7 +327,7 @@ void irias_add_integer_attrib(struct ias
 	}
 
 	attrib->magic = IAS_ATTRIB_MAGIC;
-	attrib->name = strndup(name, IAS_MAX_ATTRIBNAME);
+	attrib->name = kstrndup(name, IAS_MAX_ATTRIBNAME, GFP_ATOMIC);
 
 	/* Insert value */
 	attrib->value = irias_new_integer_value(value);
@@ -404,7 +371,7 @@ void irias_add_octseq_attrib(struct ias_
 	}
 
 	attrib->magic = IAS_ATTRIB_MAGIC;
-	attrib->name = strndup(name, IAS_MAX_ATTRIBNAME);
+	attrib->name = kstrndup(name, IAS_MAX_ATTRIBNAME, GFP_ATOMIC);
 
 	attrib->value = irias_new_octseq_value( octets, len);
 	if (!attrib->name || !attrib->value) {
@@ -446,7 +413,7 @@ void irias_add_string_attrib(struct ias_
 	}
 
 	attrib->magic = IAS_ATTRIB_MAGIC;
-	attrib->name = strndup(name, IAS_MAX_ATTRIBNAME);
+	attrib->name = kstrndup(name, IAS_MAX_ATTRIBNAME, GFP_ATOMIC);
 
 	attrib->value = irias_new_string_value(value);
 	if (!attrib->name || !attrib->value) {
@@ -506,7 +473,7 @@ struct ias_value *irias_new_string_value
 
 	value->type = IAS_STRING;
 	value->charset = CS_ASCII;
-	value->t.string = strndup(string, IAS_MAX_STRING);
+	value->t.string = kstrndup(string, IAS_MAX_STRING, GFP_ATOMIC);
 	if (!value->t.string) {
 		IRDA_WARNING("%s: Unable to kmalloc!\n", __FUNCTION__);
 		kfree(value);
_

Patches currently in -mm which might be from jeremy@goop.org are

add-kstrndup-fix.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
lguest-the-guest-code.patch
