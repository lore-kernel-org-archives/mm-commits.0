Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC89C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 22:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbhLJWtt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 17:49:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56890 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344718AbhLJWtt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 17:49:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8431ECE2D7E
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 22:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1588CC00446;
        Fri, 10 Dec 2021 22:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639176370;
        bh=t75EP32Wqn+V6jVouKzkBMZHdJbz4sx4tnkOr0TQI+k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=DOk08XWnoouLxle+q+RoadDus9vchXe8Oluap+ISQ2PFYWFzBi/vP+TA9PsrJnYXx
         1RMx2HV8MJw7v/+24YK8cMYc6woXSFPOobGDn4Fy4kVzfKDHEyNfT1vXM77+TjAaVV
         MP+a/S7GKBuEed6aTNYWwltxWG2/T9w7IZABrwJ4=
Date:   Fri, 10 Dec 2021 14:46:09 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ammarfaizi2@gnuweeb.org,
        andrew@donacou.ch, asml.silence@gmail.com, axboe@kernel.dk,
        chrubis@suse.cz, david@redhat.com, hannes@cmpxchg.org,
        jgg@ziepe.ca, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        sir@cmpwn.com, torvalds@linux-foundation.org
Subject:  [patch 01/21] Increase default MLOCK_LIMIT to 8 MiB
Message-ID: <20211210224609.9QkKor7T0%akpm@linux-foundation.org>
In-Reply-To: <20211210144539.663efee2c80d8450e6180230@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
