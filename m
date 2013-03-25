From: akpm@linux-foundation.org
Subject: + scripts-tagssh-add-magic-for-offset-and-define.patch added to -mm tree
Date: Mon, 25 Mar 2013 14:16:00 -0700
Message-ID: <20130325211600.7DF6C5A41C6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:49867 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603Ab3CYVQB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 17:16:01 -0400
Received: by mail-yh0-f74.google.com with SMTP id i57so365040yha.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 14:16:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tkhai@yandex.ru, mmarek@suse.cz


The patch titled
     Subject: scripts/tags.sh: add magic for OFFSET and DEFINE
has been added to the -mm tree.  Its filename is
     scripts-tagssh-add-magic-for-offset-and-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
scripts-tagssh-add-magic-for-offset-and-define.patch

