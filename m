From: akpm@linux-foundation.org
Subject: + flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use.patch added to -mm tree
Date: Wed, 04 Aug 2010 14:38:14 -0700
Message-ID: <201008042138.o74LcEX5011403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047Ab0HDVjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 17:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eparis@redhat.com, dave@linux.vnet.ibm.com, jmorris@namei.org, joe@perches.com, rientjes@google.com


The patch titled
     flex_array: add helpers to get and put to make pointers easy to use
has been added to the -mm tree.  Its filename is
     flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: add helpers to get and put to make pointers easy to use
From: Eric Paris <eparis@redhat.com>

Getting and putting arrays of pointers with flex arrays is a PITA.  You
have to remember to pass &ptr to the _put and you have to do weird and
wacky casting to get the ptr back from the _get.  Add two functions
flex_array_get_ptr() and flex_array_put_ptr() to handle all of the magic.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    6 ++++++
 lib/flex_array.c           |   25 ++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff -puN include/linux/flex_array.h~flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use
+++ a/include/linux/flex_array.h
@@ -70,4 +70,10 @@ int flex_array_clear(struct flex_array *
 void *flex_array_get(struct flex_array *fa, unsigned int element_nr);
 int flex_array_shrink(struct flex_array *fa);
 
+#define flex_array_put_ptr(fa, nr, src, gfp)	({						\
+						 void *_src = (src);				\
+						 flex_array_put((fa), (nr), &_src, (gfp));	\
+						})
+void *flex_array_get_ptr(struct flex_array *fa, unsigned int element_nr);
+
 #endif /* _FLEX_ARRAY_H */
diff -puN lib/flex_array.c~flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use lib/flex_array.c
--- a/lib/flex_array.c~flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use
+++ a/lib/flex_array.c
@@ -171,6 +171,8 @@ __fa_get_part(struct flex_array *fa, int
  * Note that this *copies* the contents of @src into
  * the array.  If you are trying to store an array of
  * pointers, make sure to pass in &ptr instead of ptr.
+ * You may instead wish to use the flex_array_put_ptr()
+ * helper function.
  *
  * Locking must be provided by the caller.
  */
@@ -265,7 +267,8 @@ int flex_array_prealloc(struct flex_arra
  *
  * Returns a pointer to the data at index @element_nr.  Note
  * that this is a copy of the data that was passed in.  If you
- * are using this to store pointers, you'll get back &ptr.
+ * are using this to store pointers, you'll get back &ptr.  You
+ * may instead wish to use the flex_array_get_ptr helper.
  *
  * Locking must be provided by the caller.
  */
@@ -286,6 +289,26 @@ void *flex_array_get(struct flex_array *
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
 
+/**
+ * flex_array_get_ptr - pull a ptr back out of the array
+ * @fa:		the flex array from which to extract data
+ * @element_nr:	index of the element to fetch from the array
+ *
+ * Returns the pointer placed in the flex array at element_nr using
+ * flex_array_put_ptr().  This function should not be called if the
+ * element in question was not set using the _put_ptr() helper.
+ */
+void *flex_array_get_ptr(struct flex_array *fa, unsigned int element_nr)
+{
+	void **tmp;
+
+	tmp = flex_array_get(fa, element_nr);
+	if (!tmp)
+		return NULL;
+
+	return *tmp;
+}
+
 static int part_is_free(struct flex_array_part *part)
 {
 	int i;
_

Patches currently in -mm which might be from eparis@redhat.com are

origin.patch
linux-next.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
vfs-o_-bit-numbers-uniqueness-check.patch
flex_array-add-helpers-to-get-and-put-to-make-pointers-easy-to-use.patch

