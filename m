From: akpm@linux-foundation.org
Subject: [patch 015/142] scripts/tags.sh: include arch/Kconfig* for tags
 generation
Date: Wed, 22 Feb 2017 15:40:29 -0800
Message-ID: <58ae216d.0v0sEJ5xPY9iEUQ/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934300AbdBVXlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, houtao1@huawei.com, joe@perches.com, mathieu.maret@gmail.com, mmarek@suse.com

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
