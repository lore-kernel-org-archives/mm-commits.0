From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 50/54] exec: use flush_icache_user_range in
 read_code
Date: Sun, 07 Jun 2020 21:42:43 -0700
Message-ID: <20200608044243.b-G7FjUW2%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbgFHEmp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 00:42:45 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Christoph Hellwig <hch@lst.de>
Subject: exec: use flush_icache_user_range in read_code

read_code operates on user addresses.

Link: http://lkml.kernel.org/r/20200515143646.3857579-27-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/exec.c~exec-use-flush_icache_user_range-in-read_code
+++ a/fs/exec.c
@@ -1059,7 +1059,7 @@ ssize_t read_code(struct file *file, uns
 {
 	ssize_t res = vfs_read(file, (void __user *)addr, len, &pos);
 	if (res > 0)
-		flush_icache_range(addr, addr + len);
+		flush_icache_user_range(addr, addr + len);
 	return res;
 }
 EXPORT_SYMBOL(read_code);
_
