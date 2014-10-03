From: akpm@linux-foundation.org
Subject: + increase-the-buffer-head-per-cpu-lru-size.patch added to -mm
 tree
Date: Fri, 03 Oct 2014 12:26:25 -0700
Message-ID: <542ef861.7uJPY8hS5iWh7ybo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaJCT0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2014 15:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.buisson@bull.net, andreas.dilger@intel.com, liang.zhen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: increase the buffer-head per-CPU LRU size
has been added to the -mm tree.  Its filename is
     increase-the-buffer-head-per-cpu-lru-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/increase-the-buffer-head-per-cpu-lru-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/increase-the-buffer-head-per-cpu-lru-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastien Buisson <sebastien.buisson@bull.net>
Subject: fs/buffer.c: increase the buffer-head per-CPU LRU size

Increase the buffer-head per-CPU LRU size to allow efficient filesystem
operations that access many blocks for each transaction.  For example,
creating a file in a large ext4 directory with quota enabled will access
multiple buffer heads and will overflow the LRU at the default 8-block LRU
size:

* parent directory inode table block (ctime, nlinks for subdirs)
* new inode bitmap
* inode table block
* 2 quota blocks
* directory leaf block (not reused, but pollutes one cache entry)
* 2 levels htree blocks (only one is reused, other pollutes cache)
* 2 levels indirect/index blocks (only one is reused)

The buffer-head per-CPU LRU size is raised to 16, as it shows in metadata
performance benchmarks up to 10% gain for create, 4% for lookup and 7% for
destroy.

Signed-off-by: Liang Zhen <liang.zhen@intel.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~increase-the-buffer-head-per-cpu-lru-size fs/buffer.c
--- a/fs/buffer.c~increase-the-buffer-head-per-cpu-lru-size
+++ a/fs/buffer.c
@@ -1255,7 +1255,7 @@ static struct buffer_head *__bread_slow(
  * a local interrupt disable for that.
  */
 
-#define BH_LRU_SIZE	8
+#define BH_LRU_SIZE	16
 
 struct bh_lru {
 	struct buffer_head *bhs[BH_LRU_SIZE];
_

Patches currently in -mm which might be from sebastien.buisson@bull.net are

increase-the-buffer-head-per-cpu-lru-size.patch

