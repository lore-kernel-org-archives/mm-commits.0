From: akpm@linux-foundation.org
Subject: [merged] update-thunderbird-docs-with-wordwrap-plugin.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:24 -0800
Message-ID: <201101132011.p0DKB56K030124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933690Ab1AMULn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rlandley@parallels.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/email-clients.txt: update Thunderbird docs with wordwrap plugin
has been removed from the -mm tree.  Its filename was
     update-thunderbird-docs-with-wordwrap-plugin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/email-clients.txt: update Thunderbird docs with wordwrap plugin
From: Rob Landley <rlandley@parallels.com>

Show how to install the "toggle wordwrap" extension in thunderbird.

Signed-off-by: Rob Landley <rlandley@parallels.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |   43 ++++++++++++++++--------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff -puN Documentation/email-clients.txt~update-thunderbird-docs-with-wordwrap-plugin Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~update-thunderbird-docs-with-wordwrap-plugin
+++ a/Documentation/email-clients.txt
@@ -186,26 +186,8 @@ Sylpheed (GUI)
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Thunderbird (GUI)
 
-By default, thunderbird likes to mangle text, but there are ways to
-coerce it into being nice.
-
-- Under account settings, composition and addressing, uncheck "Compose
-  messages in HTML format".
-
-- Edit your Thunderbird config settings to tell it not to wrap lines:
-      user_pref("mailnews.wraplength", 0);
-
-- Edit your Thunderbird config settings so that it won't use format=flowed:
-      user_pref("mailnews.send_plaintext_flowed", false);
-
-- You need to get Thunderbird into preformat mode:
-. If you compose HTML messages by default, it's not too hard. Just select
-  "Preformat" from the drop-down box just under the subject line.
-. If you compose in text by default, you have to tell it to compose a new
-  message in HTML (just as a one-off), and then force it from there back to
-  text, else it will wrap lines. To do this, use shift-click on the Write
-  icon to compose to get HTML compose mode, then select "Preformat" from
-  the drop-down box just under the subject line.
+Thunderbird is an Outlook clone that likes to mangle text, but there are ways
+to coerce it into behaving.
 
 - Allows use of an external editor:
   The easiest thing to do with Thunderbird and patches is to use an
@@ -215,6 +197,27 @@ coerce it into being nice.
   View->Toolbars->Customize... and finally just click on it when in the
   Compose dialog.
 
+To beat some sense out of the internal editor, do this:
+
+- Under account settings, composition and addressing, uncheck "Compose
+  messages in HTML format".
+
+- Edit your Thunderbird config settings so that it won't use format=flowed.
+  Go to "edit->preferences->advanced->config editor" to bring up the
+  thunderbird's registry editor, and set "mailnews.send_plaintext_flowed" to
+  "false".
+
+- Enable "preformat" mode: Shft-click on the Write icon to bring up the HTML
+  composer, select "Preformat" from the drop-down box just under the subject
+  line, then close the message without saving.  (This setting also applies to
+  the text composer, but the only control for it is in the HTML composer.)
+
+- Install the "toggle wordwrap" extension.  Download the file from:
+    https://addons.mozilla.org/thunderbird/addon/2351/
+  Then go to "tools->add ons", select "install" at the bottom of the screen,
+  and browse to where you saved the .xul file.  This adds an "Enable
+  Wordwrap" entry under the Options menu of the message composer.
+
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 TkRat (GUI)
 
_

Patches currently in -mm which might be from rlandley@parallels.com are

origin.patch

