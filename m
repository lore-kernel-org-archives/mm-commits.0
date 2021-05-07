Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E0EC433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D545613C9
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEGBGC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhEGBGC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E56A61041;
        Fri,  7 May 2021 01:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349503;
        bh=I3SeJ6HRy1Z7CPZFZRWgezQYkFbLw0hT9hCBb4UYLzQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JFrkk4GTD8KoKNdroSCC9Tw3edQMKQoebXXvHGdog/3SMk+JITBCjinmsuOrmVKqZ
         2Liol+0DI3gGLHW8nYFVPrefssPBQpEux/XwPpDz64/fnoWv3l/nCz29AlP4BlkOdR
         Gk0qOI/7FAQuehEf8NuoeT9R8J673P9KaAzuel6Q=
Date:   Thu, 06 May 2021 18:05:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jan.kiszka@siemens.com,
        johannes.berg@intel.com, kbingham@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 58/91] gdb: lx-symbols: store the abspath()
Message-ID: <20210507010503.UbLiMisse%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>
Subject: gdb: lx-symbols: store the abspath()

If we store the relative path, the user might later cd to a different
directory, and that would break the automatic symbol resolving that
happens when a module is loaded into the target kernel.  Fix this by
storing the abspath() of each path given, just like we already do for the
cwd (os.getcwd() is absolute.)

Link: https://lkml.kernel.org/r/20201217091747.bf4332cf2b35.I10ebbdb7e9b80ab1a5cddebf53d073be8232d656@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~gdb-lx-symbols-store-the-abspath
+++ a/scripts/gdb/linux/symbols.py
@@ -164,7 +164,8 @@ lx-symbols command."""
             saved_state['breakpoint'].enabled = saved_state['enabled']
 
     def invoke(self, arg, from_tty):
-        self.module_paths = [os.path.expanduser(p) for p in arg.split()]
+        self.module_paths = [os.path.abspath(os.path.expanduser(p))
+                             for p in arg.split()]
         self.module_paths.append(os.getcwd())
 
         # enforce update
_
