Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E13C04A94
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 19:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjHHT6z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbjHHT63 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 15:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB57E7A1E4
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59E64629BC
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDB8C433C7;
        Tue,  8 Aug 2023 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691518597;
        bh=gHLr1baTwZ9D/jALcsncKZRpNKbAAQI1+WmuRFdhHmY=;
        h=Date:To:From:Subject:From;
        b=E1JlemR5yvs58tVvcmdnrd4BB44hRVZO1XWQIIKjyXbbqk3cllFuvvx61o07N/7yQ
         5+/mSUmwQDPqmmNKG9sJUX5BbfMHM3UZFmZCiU1Ec344lG9Aw0zTehiZWx9rpiKF7M
         nNs6NIORA++/LQKJBHf2tw6jfAtDdtoJVxuPJ6rc=
Date:   Tue, 08 Aug 2023 11:16:36 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-utils-add-common-type-usage.patch added to mm-nonmm-unstable branch
Message-Id: <20230808181637.ADDB8C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/gdb/utils: add common type usage
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-utils-add-common-type-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-utils-add-common-type-usage.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Subject: scripts/gdb/utils: add common type usage
Date: Tue, 8 Aug 2023 16:30:13 +0800

Since we often use 'unsigned long', 'size_t', 'usigned int'
and 'struct page', we add these common types to utils.

Link: https://lkml.kernel.org/r/20230808083020.22254-4-Kuan-Ying.Lee@mediatek.com
Signed-off-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/utils.py |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/scripts/gdb/linux/utils.py~scripts-gdb-utils-add-common-type-usage
+++ a/scripts/gdb/linux/utils.py
@@ -35,12 +35,32 @@ class CachedType:
 
 
 long_type = CachedType("long")
+ulong_type = CachedType("unsigned long")
+uint_type = CachedType("unsigned int")
 atomic_long_type = CachedType("atomic_long_t")
+size_t_type = CachedType("size_t")
+struct_page_type = CachedType("struct page")
+
+def get_uint_type():
+    global uint_type
+    return uint_type.get_type()
+
+def get_page_type():
+    global struct_page_type
+    return struct_page_type.get_type()
 
 def get_long_type():
     global long_type
     return long_type.get_type()
 
+def get_ulong_type():
+    global ulong_type
+    return ulong_type.get_type()
+
+def get_size_t_type():
+    global size_t_type
+    return size_t_type.get_type()
+
 def offset_of(typeobj, field):
     element = gdb.Value(0).cast(typeobj)
     return int(str(element[field].address).split()[0], 16)
_

Patches currently in -mm which might be from Kuan-Ying.Lee@mediatek.com are

scripts-gdb-fix-lx-lsmod-show-the-wrong-size.patch
scripts-gdb-symbols-add-specific-ko-module-load-command.patch
scripts-gdb-modules-add-get-module-text-support.patch
scripts-gdb-utils-add-common-type-usage.patch
scripts-gdb-aarch64-add-aarch64-page-operation-helper-commands-and-configs.patch
scripts-gdb-stackdepot-add-stackdepot-support.patch
scripts-gdb-page_owner-add-page-owner-support.patch
scripts-gdb-slab-add-slab-support.patch
scripts-gdb-vmalloc-add-vmallocinfo-support.patch

