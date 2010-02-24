From: akpm@linux-foundation.org
Subject: + module-init-sysfs-attributes.patch added to -mm tree
Date: Wed, 24 Feb 2010 11:56:57 -0800
Message-ID: <201002241956.o1OJuvbq017020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757889Ab0BXT51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:57:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, rusty@rustcorp.com.au


The patch titled
     module: init sysfs attributes
has been added to the -mm tree.  Its filename is
     module-init-sysfs-attributes.patch

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
Subject: module: init sysfs attributes
From: Johannes Berg <johannes@sipsolutions.net>

This is required for lockdep.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/module.c~module-init-sysfs-attributes kernel/module.c
--- a/kernel/module.c~module-init-sysfs-attributes
+++ a/kernel/module.c
@@ -1091,6 +1091,7 @@ static void add_sect_attrs(struct module
 		sect_attrs->nsections++;
 		sattr->mattr.show = module_sect_show;
 		sattr->mattr.store = NULL;
+		sysfs_attr_init(&sattr->mattr.attr);
 		sattr->mattr.attr.name = sattr->name;
 		sattr->mattr.attr.mode = S_IRUGO;
 		*(gattr++) = &(sattr++)->mattr.attr;
@@ -1184,6 +1185,7 @@ static void add_notes_attrs(struct modul
 		if (sect_empty(&sechdrs[i]))
 			continue;
 		if (sechdrs[i].sh_type == SHT_NOTE) {
+			sysfs_bin_attr_init(nattr);
 			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = sechdrs[i].sh_size;
@@ -1256,6 +1258,7 @@ int module_add_modinfo_attrs(struct modu
 		if (!attr->test ||
 		    (attr->test && attr->test(mod))) {
 			memcpy(temp_attr, attr, sizeof(*temp_attr));
+			sysfs_attr_init(&temp_attr->attr);
 			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
 			++temp_attr;
 		}
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
linux-next.patch
module-init-sysfs-attributes.patch

