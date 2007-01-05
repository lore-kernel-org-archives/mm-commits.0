From: akpm@osdl.org
Subject: + remove-unnecessary-memset0-calls-after-kzalloc-calls.patch added to -mm tree
Date: Fri, 05 Jan 2007 11:52:33 -0800
Message-ID: <200701051952.l05JqXrT030573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbXAETx2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 14:53:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, ak@suse.de, ambx1@neo.rr.com, dtor@mail.ru


The patch titled
     Remove unnecessary memset(0) calls after kzalloc() calls.
has been added to the -mm tree.  Its filename is
     remove-unnecessary-memset0-calls-after-kzalloc-calls.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unnecessary memset(0) calls after kzalloc() calls.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete the few remaining unnecessary calls to memset(0) after a call to
kzalloc().

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/mce_amd.c   |    2 --
 drivers/input/gameport/ns558.c |    1 -
 drivers/pnp/pnpbios/rsparser.c |    1 -
 3 files changed, 4 deletions(-)

diff -puN arch/x86_64/kernel/mce_amd.c~remove-unnecessary-memset0-calls-after-kzalloc-calls arch/x86_64/kernel/mce_amd.c
--- a/arch/x86_64/kernel/mce_amd.c~remove-unnecessary-memset0-calls-after-kzalloc-calls
+++ a/arch/x86_64/kernel/mce_amd.c
@@ -401,7 +401,6 @@ static __cpuinit int allocate_threshold_
 	b = kzalloc(sizeof(struct threshold_block), GFP_KERNEL);
 	if (!b)
 		return -ENOMEM;
-	memset(b, 0, sizeof(struct threshold_block));
 
 	b->block = block;
 	b->bank = bank;
@@ -490,7 +489,6 @@ static __cpuinit int threshold_create_ba
 		err = -ENOMEM;
 		goto out;
 	}
-	memset(b, 0, sizeof(struct threshold_bank));
 
 	kobject_set_name(&b->kobj, "threshold_bank%i", bank);
 	b->kobj.parent = &per_cpu(device_mce, cpu).kobj;
diff -puN drivers/input/gameport/ns558.c~remove-unnecessary-memset0-calls-after-kzalloc-calls drivers/input/gameport/ns558.c
--- a/drivers/input/gameport/ns558.c~remove-unnecessary-memset0-calls-after-kzalloc-calls
+++ a/drivers/input/gameport/ns558.c
@@ -151,7 +151,6 @@ static int ns558_isa_probe(int io)
 		return -ENOMEM;
 	}
 
-	memset(ns558, 0, sizeof(struct ns558));
 	ns558->io = io;
 	ns558->size = 1 << i;
 	ns558->gameport = port;
diff -puN drivers/pnp/pnpbios/rsparser.c~remove-unnecessary-memset0-calls-after-kzalloc-calls drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~remove-unnecessary-memset0-calls-after-kzalloc-calls
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -530,7 +530,6 @@ pnpbios_parse_compatible_ids(unsigned ch
 			dev_id =  kzalloc(sizeof (struct pnp_id), GFP_KERNEL);
 			if (!dev_id)
 				return NULL;
-			memset(dev_id, 0, sizeof(struct pnp_id));
 			pnpid32_to_pnpid(p[1] | p[2] << 8 | p[3] << 16 | p[4] << 24,id);
 			memcpy(&dev_id->id, id, 7);
 			pnp_add_id(dev_id, dev);
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
