From: akpm@linux-foundation.org
Subject: - sound-update-snd_assert-macro.patch removed from -mm tree
Date: Thu, 02 Oct 2008 15:16:33 -0700
Message-ID: <200810022216.m92MGXrb029265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbYJBWRo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Oct 2008 18:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, srostedt@redhat.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     sound: update snd_assert macro
has been removed from the -mm tree.  Its filename was
     sound-update-snd_assert-macro.patch

This patch was dropped because snd_assert got removed

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound: update snd_assert macro
From: Steven Rostedt <rostedt@goodmis.org>

One user of the snd_assert macro calls a goto and the compiler complains
that the label is not used when the snd_assert is not set.

This patch makes snd_assert more robust when not defined to let the
compiler know about arguments when not in use.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/sound/core.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/sound/core.h~sound-update-snd_assert-macro include/sound/core.h
--- a/include/sound/core.h~sound-update-snd_assert-macro
+++ a/include/sound/core.h
@@ -407,7 +407,13 @@ void snd_verbose_printd(const char *file
 #else /* !CONFIG_SND_DEBUG */
 
 #define snd_printd(fmt, args...)	/* nothing */
-#define snd_assert(expr, args...)	(void)(expr)
+/* Keep the compiler happy by showing the expr and args */
+#define snd_assert(expr, args...)	do {	\
+	if (0) {				\
+		(void)(expr);			\
+		args;				\
+	}					\
+} while(0)
 #define snd_BUG()			/* nothing */
 
 #endif /* CONFIG_SND_DEBUG */
_

Patches currently in -mm which might be from rostedt@goodmis.org are

git-x86.patch
git-ftrace.patch
sound-update-snd_assert-macro.patch
ftrace-warn-on-failure-to-disable-mcount-callers.patch

