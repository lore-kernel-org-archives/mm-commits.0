Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51445C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 13 Dec 2021 17:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241258AbhLMRWf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Dec 2021 12:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbhLMRWf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Dec 2021 12:22:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5BA8C061574
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 09:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50091B811E3
        for <mm-commits@vger.kernel.org>; Mon, 13 Dec 2021 17:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3E8C34602;
        Mon, 13 Dec 2021 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639416152;
        bh=5U0wNUB4dYc/kcT/S1w6iH73phMz1HMsI6rBsLyb+gc=;
        h=Date:From:To:Subject:From;
        b=Zah/KdBz7+cU1wQoCxmcXoDtFuqJbfL/z399SzEgy5ZvvoPDZbB8vL5ACXrEx9eFE
         JNrdRKIpuFK1vE0GuC+nlJt2c/H0aHyO5ECe7UoJ0KSHhcKO8xUkb3IitBbuahRLVo
         saY4VNEQ2yZsIDSsTgOymHQWU+PX/0MV84pIfjYw=
Date:   Mon, 13 Dec 2021 09:22:30 -0800
From:   akpm@linux-foundation.org
To:     ammarfaizi2@gnuweeb.org, andrew@donacou.ch, asml.silence@gmail.com,
        axboe@kernel.dk, chrubis@suse.cz, david@redhat.com,
        hannes@cmpxchg.org, jgg@ziepe.ca, mm-commits@vger.kernel.org,
        sir@cmpwn.com
Subject:  [alternative-merged]
 increase-default-mlock_limit-to-8-mib.patch removed from -mm tree
Message-ID: <20211213172230.fNfqRPoau%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Increase default MLOCK_LIMIT to 8 MiB
has been removed from the -mm tree.  Its filename was
     increase-default-mlock_limit-to-8-mib.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Drew DeVault <sir@cmpwn.com>
Subject: Increase default MLOCK_LIMIT to 8 MiB

This limit has not been updated since 2008, when it was increased to 64
KiB at the request of GnuPG.  Until recently, the main use-cases for this
feature were (1) preventing sensitive memory from being swapped, as in
GnuPG's use-case; and (2) real-time use-cases.  In the first case, little
memory is called for, and in the second case, the user is generally in a
position to increase it if they need more.

The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
preparing fixed buffers for high-performance I/O.  This use-case will take
as much of this memory as it can get, but is still limited to 64 KiB by
default, which is very little.  This increases the limit to 8 MB, which
was chosen fairly arbitrarily as a more generous, but still conservative,
default value.

It is also possible to raise this limit in userspace.  This is easily
done, for example, in the use-case of a network daemon: systemd, for
instance, provides for this via LimitMEMLOCK in the service file; OpenRC
via the rc_ulimit variables.  However, there is no established userspace
facility for configuring this outside of daemons: end-user applications do
not presently have access to a convenient means of raising their limits.

The buck, as it were, stops with the kernel.  It's much easier to address
it here than it is to bring it to hundreds of distributions, and it can
only realistically be relied upon to be high-enough by end-user software
if it is more-or-less ubiquitous.  Most distros don't change this
particular rlimit from the kernel-supplied default value, so a change here
will easily provide that ubiquity.

Link: https://lkml.kernel.org/r/20211028080813.15966-1-sir@cmpwn.com
Signed-off-by: Drew DeVault <sir@cmpwn.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Cyril Hrubis <chrubis@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Andrew Dona-Couch <andrew@donacou.ch>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/resource.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/include/uapi/linux/resource.h~increase-default-mlock_limit-to-8-mib
+++ a/include/uapi/linux/resource.h
@@ -66,10 +66,17 @@ struct rlimit64 {
 #define _STK_LIM	(8*1024*1024)
 
 /*
- * GPG2 wants 64kB of mlocked memory, to make sure pass phrases
- * and other sensitive information are never written to disk.
+ * Limit the amount of locked memory by some sane default:
+ * root can always increase this limit if needed.
+ *
+ * The main use-cases are (1) preventing sensitive memory
+ * from being swapped; (2) real-time operations; (3) via
+ * IOURING_REGISTER_BUFFERS.
+ *
+ * The first two don't need much. The latter will take as
+ * much as it can get. 8MB is a reasonably sane default.
  */
-#define MLOCK_LIMIT	((PAGE_SIZE > 64*1024) ? PAGE_SIZE : 64*1024)
+#define MLOCK_LIMIT	((PAGE_SIZE > 8*1024*1024) ? PAGE_SIZE : 8*1024*1024)
 
 /*
  * Due to binary compatibility, the actual resource numbers
_

Patches currently in -mm which might be from sir@cmpwn.com are


