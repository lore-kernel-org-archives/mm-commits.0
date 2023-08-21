Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26BEEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjHUUrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjHUUrI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E76B132
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D4D1646DE
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757E9C433C7;
        Mon, 21 Aug 2023 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650819;
        bh=OzDbhq1wglIsX5lmRrkBm2Uv8NpH3g+NLw0zy02E6So=;
        h=Date:To:From:Subject:From;
        b=l8QDcFGjZKG2opiXHRqgiMP2cs8kuC2Jl8QpQXABXVlvFpl+IU59BwjmcMrpI+vp6
         KvSotReMyV74HhwYhcz9hDGWGyHRHKiwIo8Np/sJzZo53ASfDUYBplwokeWIY8a50X
         /z/kAt2bX6+drtcpa3Rw2zW0KcE1Rj3warMxRA0Y=
Date:   Mon, 21 Aug 2023 13:46:58 -0700
To:     mm-commits@vger.kernel.org, qun-wei.lin@mediatek.com,
        matthias.bgg@gmail.com, chinwen.chang@mediatek.com,
        angelogioacchino.delregno@collabora.com,
        Kuan-Ying.Lee@mediatek.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-gdb-utils-add-common-type-usage.patch removed from -mm tree
Message-Id: <20230821204659.757E9C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: scripts/gdb/utils: add common type usage
has been removed from the -mm tree.  Its filename was
     scripts-gdb-utils-add-common-type-usage.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


