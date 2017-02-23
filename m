From: akpm@linux-foundation.org
Subject: [merged]
 scripts-tagssh-include-arch-kconfig-for-tags-generation.patch removed from
 -mm tree
Date: Thu, 23 Feb 2017 13:11:45 -0800
Message-ID: <58af5011.WzLIWt0qQKUwLXQG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38454 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbdBWVLq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: houtao1@huawei.com, joe@perches.com, mathieu.maret@gmail.com, mmarek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: include arch/Kconfig* for tags generation
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-include-arch-kconfig-for-tags-generation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


