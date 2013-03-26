From: akpm@linux-foundation.org
Subject: [nacked] scripts-tagssh-add-magic-for-offset-and-define.patch removed from -mm tree
Date: Tue, 26 Mar 2013 14:43:47 -0700
Message-ID: <20130326214347.6BFC45A42CA@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48107 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3CZVns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 17:43:48 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so769970vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 14:43:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkhai@yandex.ru, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: add magic for OFFSET and DEFINE
has been removed from the -mm tree.  Its filename was
     scripts-tagssh-add-magic-for-offset-and-define.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Kirill Tkhai <tkhai@yandex.ru>
Subject: scripts/tags.sh: add magic for OFFSET and DEFINE

Add rules for definitions which is generally used in asm-offsets files.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/tags.sh~scripts-tagssh-add-magic-for-offset-and-define scripts/tags.sh
--- a/scripts/tags.sh~scripts-tagssh-add-magic-for-offset-and-define
+++ a/scripts/tags.sh
@@ -199,7 +199,9 @@ exuberant()
 	--regex-c='/DEFINE_PER_CPU_SHARED_ALIGNED\(([^,]*,\s*)(\w*).*\)/\2/v/' \
 	--regex-c='/DECLARE_WAIT_QUEUE_HEAD\((\w*)/\1/v/'		\
 	--regex-c='/DECLARE_(TASKLET|WORK|DELAYED_WORK)\((\w*)/\2/v/'	\
-	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'
+	--regex-c='/DEFINE_PCI_DEVICE_TABLE\((\w*)/\1/v/'		\
+	--regex-c='/(^\s)OFFSET\((\w*)/\2/v/'				\
+	--regex-c='/(^\s)DEFINE\((\w*)/\2/v/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
_

Patches currently in -mm which might be from tkhai@yandex.ru are

linux-next.patch

