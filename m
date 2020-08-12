Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FEABC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 469A920774
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266235;
	bh=OL0Ijux8LAIqQsou+HmWjFWKKTU2vtwiQiPYB2tTUcc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=I1omlJ+KhL6SOr5p1ZtgZsDOBi98OdbYRXvEHPRxUFAKsyzQOrFShgzZ4eihvyb11
	 uKZtBKJr2299EZyHBlGV7aEOEY9LkvrfNEsCCy3yZhIeh+f8ARcngqqnVYWT0Mb7g7
	 oc4gqgeM//aG7Q/wukS+7Rm8Yovn1rr0cq57OykY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgHLVDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgHLVDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92DB2221E2;
        Wed, 12 Aug 2020 21:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266232;
        bh=OL0Ijux8LAIqQsou+HmWjFWKKTU2vtwiQiPYB2tTUcc=;
        h=Date:From:To:Subject:From;
        b=UH3VYaBMR4gVT/Uy0RvTSB4uhMg1Tf9JcnA5I+/OMNiGuALg9t3YpYJekTXy5nREb
         pPosTyaZznQ/53KkVLi5q9Bij/E1EubhhTUWHPeZwM3zBvBwh7EhVRdBIOEDNzimQk
         Sz4h4QFGHDGD/QbUyP09HB/R+n+NSVT1P9j788YY=
Date:   Wed, 12 Aug 2020 14:03:52 -0700
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, luc.vanoostenryck@gmail.com,
        miguel.ojeda.sandonis@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged] sparse-group-the-defines-by-functionality.patch
 removed from -mm tree
Message-ID: <20200812210352.jcAuAYNQH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sparse: group the defines by functionality
has been removed from the -mm tree.  Its filename was
     sparse-group-the-defines-by-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: sparse: group the defines by functionality

By popular demand, reorder the defines for sparse annotations and group
them by functionality.

Link: lore.kernel.org/r/CAMuHMdWQsirja-h3wBcZezk+H2Q_HShhAks8Hc8ps5fTAp=ObQ@mail.gmail.com
Link: http://lkml.kernel.org/r/20200621143652.53798-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |   44 +++++++++++++++++--------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/include/linux/compiler_types.h~sparse-group-the-defines-by-functionality
+++ a/include/linux/compiler_types.h
@@ -5,48 +5,54 @@
 #ifndef __ASSEMBLY__
 
 #ifdef __CHECKER__
+/* address spaces */
 # define __kernel	__attribute__((address_space(0)))
 # define __user		__attribute__((noderef, address_space(__user)))
-# define __safe		__attribute__((safe))
-# define __force	__attribute__((force))
-# define __nocast	__attribute__((nocast))
 # define __iomem	__attribute__((noderef, address_space(__iomem)))
+# define __percpu	__attribute__((noderef, address_space(__percpu)))
+# define __rcu		__attribute__((noderef, address_space(__rcu)))
+extern void __chk_user_ptr(const volatile void __user *);
+extern void __chk_io_ptr(const volatile void __iomem *);
+/* context/locking */
 # define __must_hold(x)	__attribute__((context(x,1,1)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
-# define __percpu	__attribute__((noderef, address_space(__percpu)))
-# define __rcu		__attribute__((noderef, address_space(__rcu)))
+/* other */
+# define __force	__attribute__((force))
+# define __nocast	__attribute__((nocast))
+# define __safe		__attribute__((safe))
 # define __private	__attribute__((noderef))
-extern void __chk_user_ptr(const volatile void __user *);
-extern void __chk_io_ptr(const volatile void __iomem *);
 # define ACCESS_PRIVATE(p, member) (*((typeof((p)->member) __force *) &(p)->member))
 #else /* __CHECKER__ */
+/* address spaces */
+# define __kernel
 # ifdef STRUCTLEAK_PLUGIN
-#  define __user __attribute__((user))
+#  define __user	__attribute__((user))
 # else
 #  define __user
 # endif
-# define __kernel
-# define __safe
-# define __force
-# define __nocast
 # define __iomem
-# define __chk_user_ptr(x) (void)0
-# define __chk_io_ptr(x) (void)0
-# define __builtin_warning(x, y...) (1)
+# define __percpu
+# define __rcu
+# define __chk_user_ptr(x)	(void)0
+# define __chk_io_ptr(x)	(void)0
+/* context/locking */
 # define __must_hold(x)
 # define __acquires(x)
 # define __releases(x)
-# define __acquire(x) (void)0
-# define __release(x) (void)0
+# define __acquire(x)	(void)0
+# define __release(x)	(void)0
 # define __cond_lock(x,c) (c)
-# define __percpu
-# define __rcu
+/* other */
+# define __force
+# define __nocast
+# define __safe
 # define __private
 # define ACCESS_PRIVATE(p, member) ((p)->member)
+# define __builtin_warning(x, y...) (1)
 #endif /* __CHECKER__ */
 
 /* Indirect macros required for expanded argument pasting, eg. __LINE__. */
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are


