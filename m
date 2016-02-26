From: akpm@linux-foundation.org
Subject: + staging-goldfish-use-6-arg-get_user_pages.patch added to -mm
 tree
Date: Fri, 26 Feb 2016 13:27:45 -0800
Message-ID: <56d0c351.Tl8vteGqLxg5i7F2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbcBZV1q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 16:27:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dave.hansen@linux.intel.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: staging/goldfish: use 6-arg get_user_pages()
has been added to the -mm tree.  Its filename is
     staging-goldfish-use-6-arg-get_user_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/staging-goldfish-use-6-arg-get_user_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/staging-goldfish-use-6-arg-get_user_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: staging/goldfish: use 6-arg get_user_pages()

After commit cde70140fed8 ("mm/gup: Overload get_user_pages() functions"),
we get warning for this file, as it calls get_user_pages() with eight
arguments after the change of the calling convention to use only six:

drivers/platform/goldfish/goldfish_pipe.c: In function 'goldfish_pipe_read_write':
drivers/platform/goldfish/goldfish_pipe.c:312:3: error: 'get_user_pages8' is deprecated [-Werror=deprecated-declarations]

This removes the first two arguments, which are now the default.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/goldfish/goldfish_pipe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/platform/goldfish/goldfish_pipe.c~staging-goldfish-use-6-arg-get_user_pages drivers/platform/goldfish/goldfish_pipe.c
--- a/drivers/platform/goldfish/goldfish_pipe.c~staging-goldfish-use-6-arg-get_user_pages
+++ a/drivers/platform/goldfish/goldfish_pipe.c
@@ -309,8 +309,7 @@ static ssize_t goldfish_pipe_read_write(
 		 * much memory to the process.
 		 */
 		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(current, current->mm, address, 1,
-				     !is_write, 0, &page, NULL);
+		ret = get_user_pages(address, 1, !is_write, 0, &page, NULL);
 		up_read(&current->mm->mmap_sem);
 		if (ret < 0)
 			break;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-compaction-introduce-kcompactd-fix.patch
profile-hide-unused-functions-when-config_proc_fs.patch
staging-goldfish-use-6-arg-get_user_pages.patch

