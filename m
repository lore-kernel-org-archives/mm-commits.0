From: akpm@linux-foundation.org
Subject: + scripts-tagssh-include-arch-kconfig-for-tags-generation.patch
 added to -mm tree
Date: Mon, 06 Feb 2017 16:23:07 -0800
Message-ID: <5899136b.+ugGGh/hz242stio%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdBGAXI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 19:23:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: houtao1@huawei.com, joe@perches.com, mathieu.maret@gmail.com, mmarek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: include arch/Kconfig* for tags generation
has been added to the -mm tree.  Its filename is
     scripts-tagssh-include-arch-kconfig-for-tags-generation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tagssh-include-arch-kconfig-for-tags-generation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tagssh-include-arch-kconfig-for-tags-generation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hou Tao <houtao1@huawei.com>
Subject: scripts/tags.sh: include arch/Kconfig* for tags generation

Kconfig files under arch/ directory are ignored by all_kconfigs(),
so include them for tags generation.

Link: http://lkml.kernel.org/r/1486206053-38223-1-git-send-email-houtao1@huawei.com
Signed-off-by: Hou Tao <houtao1@huawei.com>
Cc: Michal Marek <mmarek@suse.com>
Cc: Joe Perches <joe@perches.com>
Cc: Mathieu Maret <mathieu.maret@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/tags.sh~scripts-tagssh-include-arch-kconfig-for-tags-generation scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-include-arch-kconfig-for-tags-generation
+++ a/scripts/tags.sh
@@ -128,6 +128,8 @@ all_target_sources()
 
 all_kconfigs()
 {
+	find ${tree}arch/ -maxdepth 1 $ignore \
+	       -name "Kconfig*" -not -type l -print;
 	for arch in $ALLSOURCE_ARCHS; do
 		find_sources $arch 'Kconfig*'
 	done
_

Patches currently in -mm which might be from houtao1@huawei.com are

scripts-tagssh-include-arch-kconfig-for-tags-generation.patch

