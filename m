Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2018FC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F10E7206E9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026839;
	bh=p5yw3+SmB06+t4QeywzZXIPAhPpXaY0MiK1vwuo59GY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=mo76wvPvhbUgLWHDekckcWBPO7rj956T/IjBsrVhaRUaOpGzUa+jtkhRtyCbSNf/n
	 kzDiG5VsYzbEfOeQ4hLOJaXKyasXqpL9GysG13Zje7kehmcHBFpJ7VSSJNn86b63xt
	 1vj/qT6b+IXt9jvu88gNLC8JymOfswRVNqEOwT08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJCd6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCd6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:33:58 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76CAC206CD;
        Mon, 10 Aug 2020 02:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026837;
        bh=p5yw3+SmB06+t4QeywzZXIPAhPpXaY0MiK1vwuo59GY=;
        h=Date:From:To:Subject:From;
        b=RCnlvZJyx5GoR+W727VPklL9HyBn/umq3+Ed+NrfFVJALK2IFZoKoKPpPlc/JHnvd
         AQZKOM2C8n5R/WUeZbmvSehiTG4b/LJ8lUVo6tc56l39TMbinmhKqHB51PSCkRzkNH
         g9yHXNRpBPeXfC5pWusDZCP+6ZTfqg5LJoWeVt/A=
Date:   Sun, 09 Aug 2020 19:33:57 -0700
From:   akpm@linux-foundation.org
To:     grandmaster@al2klimov.de, mm-commits@vger.kernel.org
Subject:  [merged] tools-replace-http-links-with-https-ones.patch
 removed from -mm tree
Message-ID: <20200810023357.ujOaLevPg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/: replace HTTP links with HTTPS ones
has been removed from the -mm tree.  Its filename was
     tools-replace-http-links-with-https-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: tools/: replace HTTP links with HTTPS ones

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Link: http://lkml.kernel.org/r/20200726120752.16768-1-grandmaster@al2klimov.de
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/jhash.h                  |    2 +-
 tools/lib/rbtree.c                           |    2 +-
 tools/lib/traceevent/event-parse.h           |    2 +-
 tools/testing/ktest/examples/README          |    2 +-
 tools/testing/ktest/examples/crosstests.conf |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/include/linux/jhash.h~tools-replace-http-links-with-https-ones
+++ a/tools/include/linux/jhash.h
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2006. Bob Jenkins (bob_jenkins@burtleburtle.net)
  *
- * http://burtleburtle.net/bob/hash/
+ * https://burtleburtle.net/bob/hash/
  *
  * These are the credits from Bob's sources:
  *
--- a/tools/lib/rbtree.c~tools-replace-http-links-with-https-ones
+++ a/tools/lib/rbtree.c
@@ -13,7 +13,7 @@
 #include <linux/export.h>
 
 /*
- * red-black trees properties:  http://en.wikipedia.org/wiki/Rbtree
+ * red-black trees properties:  https://en.wikipedia.org/wiki/Rbtree
  *
  *  1) A node is either red or black
  *  2) The root is black
--- a/tools/lib/traceevent/event-parse.h~tools-replace-http-links-with-https-ones
+++ a/tools/lib/traceevent/event-parse.h
@@ -379,7 +379,7 @@ enum tep_errno {
 	 * errno since SUS requires the errno has distinct positive values.
 	 * See 'Issue 6' in the link below.
 	 *
-	 * http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
+	 * https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
 	 */
 	__TEP_ERRNO__START			= -100000,
 
--- a/tools/testing/ktest/examples/crosstests.conf~tools-replace-http-links-with-https-ones
+++ a/tools/testing/ktest/examples/crosstests.conf
@@ -3,7 +3,7 @@
 #
 # In this config, it is expected that the tool chains from:
 #
-#   http://kernel.org/pub/tools/crosstool/files/bin/x86_64/
+#   https://kernel.org/pub/tools/crosstool/files/bin/x86_64/
 #
 # running on a x86_64 system have been downloaded and installed into:
 #
--- a/tools/testing/ktest/examples/README~tools-replace-http-links-with-https-ones
+++ a/tools/testing/ktest/examples/README
@@ -11,7 +11,7 @@ crosstests.conf - this config shows an e
     lots of different architectures. It only does build tests, but makes
     it easy to compile test different archs. You can download the arch
     cross compilers from:
-  http://kernel.org/pub/tools/crosstool/files/bin/x86_64/
+  https://kernel.org/pub/tools/crosstool/files/bin/x86_64/
 
 test.conf - A generic example of a config. This is based on an actual config
      used to perform real testing.
_

Patches currently in -mm which might be from grandmaster@al2klimov.de are

include-replace-http-links-with-https-ones.patch
lib-replace-http-links-with-https-ones.patch
vfat-fat-msdos-filesystem-replace-http-links-with-https-ones.patch

