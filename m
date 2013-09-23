From: akpm@linux-foundation.org
Subject: + kernel-add-support-for-init_array-constructors-fix.patch added
 to -mm tree
Date: Mon, 23 Sep 2013 14:14:09 -0700
Message-ID: <5240af21.q9k/WqnSjy95pYkR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3IWVOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Sep 2013 17:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peter.oberparleiter@de.ibm.com, keescook@chromium.org, jstancek@redhat.com, fhrbata@redhat.com, arnd@arndb.de, agospoda@redhat.com, rusty@rustcorp.com.au

Subject: + kernel-add-support-for-init_array-constructors-fix.patch added to -mm tree
To: rusty@rustcorp.com.au,agospoda@redhat.com,arnd@arndb.de,fhrbata@redhat.com,jstancek@redhat.com,keescook@chromium.org,peter.oberparleiter@de.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 23 Sep 2013 14:14:09 -0700


The patch titled
     Subject: kernel: add support for init_array constructors
has been added to the -mm tree.  Its filename is
     kernel-add-support-for-init_array-constructors-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-support-for-init_array-constructors-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-support-for-init_array-constructors-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rusty Russell <rusty@rustcorp.com.au>
Subject: kernel: add support for init_array constructors

v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
      .ctors or .init_array, but not both at the same time
v3: - fail to load if that does happen somehow.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Gospodarek <agospoda@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN kernel/module.c~kernel-add-support-for-init_array-constructors-fix kernel/module.c
--- a/kernel/module.c~kernel-add-support-for-init_array-constructors-fix
+++ a/kernel/module.c
@@ -2738,7 +2738,7 @@ static int check_modinfo(struct module *
 	return 0;
 }
 
-static void find_module_sections(struct module *mod, struct load_info *info)
+static int find_module_sections(struct module *mod, struct load_info *info)
 {
 	mod->kp = section_objs(info, "__param",
 			       sizeof(*mod->kp), &mod->num_kp);
@@ -2771,6 +2771,15 @@ static void find_module_sections(struct
 	if (!mod->ctors)
 		mod->ctors = section_objs(info, ".init_array",
 				sizeof(*mod->ctors), &mod->num_ctors);
+	else if (find_sec(info, ".init_array")) {
+		/*
+		 * This shouldn't happen with same compiler and binutils
+		 * building all parts of the module.
+		 */
+		printk(KERN_WARNING "%s: has both .ctors and .init_array.\n",
+		       mod->name);
+		return -EINVAL;
+	}
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
@@ -2809,6 +2818,8 @@ static void find_module_sections(struct
 
 	info->debug = section_objs(info, "__verbose",
 				   sizeof(*info->debug), &info->num_debug);
+
+	return 0;
 }
 
 static int move_module(struct module *mod, struct load_info *info)
@@ -3266,7 +3277,9 @@ static int load_module(struct load_info
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	find_module_sections(mod, info);
+	err = find_module_sections(mod, info);
+	if (err)
+		goto free_unload;
 
 	err = check_module_license_and_versions(mod);
 	if (err)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

scripts-sortextable-support-objects-with-more-than-64k-sections.patch
gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-add-support-for-init_array-constructors.patch
kernel-add-support-for-init_array-constructors-fix.patch
kernel-gcov-fsc-use-pr_warn.patch

