From: akpm@linux-foundation.org
Subject: [patch 058/123] include/linux/backing-dev-defs.h: shrink struct
 backing_dev_info
Date: Mon, 12 Dec 2016 16:43:29 -0800
Message-ID: <584f4431.ZP+SvvQU0IdC88Dg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41210 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752801AbcLMAna (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk

From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/backing-dev-defs.h: shrink struct backing_dev_info

Move the 4-byte `capabilities' field next to other 4-byte things.  Shrinks
sizeof(backing_dev_info) by 8 bytes on x86_64.

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/backing-dev-defs.h~include-linux-backing-dev-defsh-shrink-struct-backing_dev_info include/linux/backing-dev-defs.h
--- a/include/linux/backing-dev-defs.h~include-linux-backing-dev-defsh-shrink-struct-backing_dev_info
+++ a/include/linux/backing-dev-defs.h
@@ -137,12 +137,12 @@ struct backing_dev_info {
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_SIZE units */
 	unsigned long io_pages;	/* max allowed IO size */
-	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
 	void *congested_data;	/* Pointer to aux data for congested func */
 
 	char *name;
 
+	unsigned int capabilities; /* Device capabilities */
 	unsigned int min_ratio;
 	unsigned int max_ratio, max_prop_frac;
 
_
