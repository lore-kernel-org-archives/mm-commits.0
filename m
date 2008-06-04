From: akpm@linux-foundation.org
Subject: + doc-add-suggestions-about-good-practices-for-maintainers.patch added to -mm tree
Date: Wed, 04 Jun 2008 13:55:09 -0700
Message-ID: <200806042055.m54KtAFm008622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbYFDUz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2008 16:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w@1wt.eu, randy.dunlap@oracle.com


The patch titled
     doc: add suggestions about good practices for maintainers
has been added to the -mm tree.  Its filename is
     doc-add-suggestions-about-good-practices-for-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: add suggestions about good practices for maintainers
From: Willy Tarreau <w@1wt.eu>

Suggest how to deal with patch modifications caused by merging or
back-porting when you're a maintainer.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   46 ++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff -puN Documentation/SubmittingPatches~doc-add-suggestions-about-good-practices-for-maintainers Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~doc-add-suggestions-about-good-practices-for-maintainers
+++ a/Documentation/SubmittingPatches
@@ -327,6 +327,52 @@ Some people also put extra tags at the e
 now, but you can do this to mark internal company procedures or just
 point out some special detail about the sign-off. 
 
+If you are a subsystem or branch maintainer, sometimes you need to slightly
+modify patches you receive in order to merge them, because the code is not
+exactly the same in your tree and the submitters'. If you stick strictly to
+rule (c), you should ask the submitter to rediff, but this is a totally
+counter-productive waste of time and energy. Rule (b) allows you to adjust
+the code, but then it is very impolite to change one submitter's code and
+make him endorse your bugs. To solve this problem, it is recommended that
+you add a line between the last Signed-off-by header and yours, indicating
+the nature of your changes. While there is nothing mandatory about this, it
+seems like prepending the description with your mail and/or name, all
+enclosed in square brackets, is noticeable enough to make it obvious that
+you are responsible for last-minute changes. Example :
+
+	Signed-off-by: Random J Developer <random@developer.example.org>
+	[lucky@maintainer.example.org: struct foo moved from foo.c to foo.h]
+	Signed-off-by: Lucky K Maintainer <lucky@maintainer.example.org>
+
+This practise is particularly helpful if you maintain a stable branch and
+want at the same time to credit the author, track changes, merge the fix,
+and protect the submitter from complaints. Note that under no circumstances
+can you change the author's identity (the From header), as it is the one
+which appears in the changelog.
+
+Special note to back-porters: It seems to be a common and useful practise
+to insert an indication of the origin of a patch at the top of the commit
+message (just after the subject line) to facilitate tracking. For instance,
+here's what we see in 2.6-stable :
+
+    Date:   Tue May 13 19:10:30 2008 +0000
+
+        SCSI: libiscsi regression in 2.6.25: fix nop timer handling
+
+        commit 4cf1043593db6a337f10e006c23c69e5fc93e722 upstream
+
+And here's what appears in 2.4 :
+
+    Date:   Tue May 13 22:12:27 2008 +0200
+
+        wireless, airo: waitbusy() won't delay
+
+        [backport of 2.6 commit b7acbdfbd1f277c1eb23f344f899cfa4cd0bf36a]
+
+Whatever the format, this information provides a valuable help to people
+tracking your trees, and to people trying to trouble-shoot bugs in your
+tree.
+
 
 13) When to use Acked-by: and Cc:
 
_

Patches currently in -mm which might be from w@1wt.eu are

doc-add-suggestions-about-good-practices-for-maintainers.patch

