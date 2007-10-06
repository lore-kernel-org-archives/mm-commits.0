From: akpm@linux-foundation.org
Subject: + documentation-vm-slabinfoc-clean-up-this-code.patch added to -mm tree
Date: Fri, 05 Oct 2007 17:02:51 -0700
Message-ID: <200710060003.l96036Kt031736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48387 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759093AbXJFADP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 20:03:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, clameter@sgi.com


The patch titled
     Documentation/vm/slabinfo.c: clean up this code
has been added to the -mm tree.  Its filename is
     documentation-vm-slabinfoc-clean-up-this-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Documentation/vm/slabinfo.c: clean up this code
From: WANG Cong <xiyou.wangcong@gmail.com>

This patch does the following cleanups for Documentation/vm/slabinfo.c:

	- Fix two memory leaks;
	- Constify some char pointers;
	- Use snprintf instead of sprintf in case of buffer overflow;
	- Fix some indentations;
	- Other little improvements.

Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/vm/slabinfo.c~documentation-vm-slabinfoc-clean-up-this-code Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~documentation-vm-slabinfoc-clean-up-this-code
+++ a/Documentation/vm/slabinfo.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <sys/types.h>
 #include <dirent.h>
+#include <strings.h>
 #include <string.h>
 #include <unistd.h>
 #include <stdarg.h>
@@ -84,7 +85,7 @@ void fatal(const char *x, ...)
 	va_start(ap, x);
 	vfprintf(stderr, x, ap);
 	va_end(ap);
-	exit(1);
+	exit(EXIT_FAILURE);
 }
 
 void usage(void)
@@ -119,14 +120,14 @@ void usage(void)
 	);
 }
 
-unsigned long read_obj(char *name)
+unsigned long read_obj(const char *name)
 {
 	FILE *f = fopen(name, "r");
 
 	if (!f)
 		buffer[0] = 0;
 	else {
-		if (!fgets(buffer,sizeof(buffer), f))
+		if (!fgets(buffer, sizeof(buffer), f))
 			buffer[0] = 0;
 		fclose(f);
 		if (buffer[strlen(buffer)] == '\n')
@@ -139,7 +140,7 @@ unsigned long read_obj(char *name)
 /*
  * Get the contents of an attribute
  */
-unsigned long get_obj(char *name)
+unsigned long get_obj(const char *name)
 {
 	if (!read_obj(name))
 		return 0;
@@ -147,7 +148,7 @@ unsigned long get_obj(char *name)
 	return atol(buffer);
 }
 
-unsigned long get_obj_and_str(char *name, char **x)
+unsigned long get_obj_and_str(const char *name, char **x)
 {
 	unsigned long result = 0;
 	char *p;
@@ -166,12 +167,12 @@ unsigned long get_obj_and_str(char *name
 	return result;
 }
 
-void set_obj(struct slabinfo *s, char *name, int n)
+void set_obj(struct slabinfo *s, const char *name, int n)
 {
 	char x[100];
 	FILE *f;
 
-	sprintf(x, "%s/%s", s->name, name);
+	snprintf(x, 100, "%s/%s", s->name, name);
 	f = fopen(x, "w");
 	if (!f)
 		fatal("Cannot write to %s\n", x);
@@ -180,13 +181,13 @@ void set_obj(struct slabinfo *s, char *n
 	fclose(f);
 }
 
-unsigned long read_slab_obj(struct slabinfo *s, char *name)
+unsigned long read_slab_obj(struct slabinfo *s, const char *name)
 {
 	char x[100];
 	FILE *f;
-	int l;
+	size_t l;
 
-	sprintf(x, "%s/%s", s->name, name);
+	snprintf(x, 100, "%s/%s", s->name, name);
 	f = fopen(x, "r");
 	if (!f) {
 		buffer[0] = 0;
@@ -453,7 +454,7 @@ void slabcache(struct slabinfo *s)
 		return;
 
 	store_size(size_str, slab_size(s));
-	sprintf(dist_str,"%lu/%lu/%d", s->slabs, s->partial, s->cpu_slabs);
+	snprintf(dist_str, 40, "%lu/%lu/%d", s->slabs, s->partial, s->cpu_slabs);
 
 	if (!line++)
 		first_line();
@@ -1062,6 +1063,7 @@ void read_slab_dir(void)
 			slab->partial = get_obj("partial");
 			slab->partial = get_obj_and_str("partial", &t);
 			decode_numa_list(slab->numa_partial, t);
+			free(t);
 			slab->poison = get_obj("poison");
 			slab->reclaim_account = get_obj("reclaim_account");
 			slab->red_zone = get_obj("red_zone");
@@ -1069,6 +1071,7 @@ void read_slab_dir(void)
 			slab->slab_size = get_obj("slab_size");
 			slab->slabs = get_obj_and_str("slabs", &t);
 			decode_numa_list(slab->numa, t);
+			free(t);
 			slab->store_user = get_obj("store_user");
 			slab->trace = get_obj("trace");
 			chdir("..");
@@ -1148,7 +1151,7 @@ int main(int argc, char *argv[])
 
 	while ((c = getopt_long(argc, argv, "ad::efhil1noprstvzTS",
 						opts, NULL)) != -1)
-	switch(c) {
+		switch (c) {
 		case '1':
 			show_single_ref = 1;
 			break;
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-net.patch
fs-romfs-inodec-trivial-improvements.patch
fs-udf-ballocc-mark-a-variable-as-uninitialized_var.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
