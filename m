From: akpm@linux-foundation.org
Subject: + watchdog-docs-fix-use-of-wdioc_setoptions-ioctl.patch added to -mm tree
Date: Mon, 05 Apr 2010 14:35:00 -0700
Message-ID: <201004052135.o35LZ0JJ010403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580Ab0DEVfk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 17:35:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: james@albanarts.com, james.hogan@imgtec.com, wim@iguana.be


The patch titled
     watchdog docs: fix use of WDIOC_SETOPTIONS ioctl
has been added to the -mm tree.  Its filename is
     watchdog-docs-fix-use-of-wdioc_setoptions-ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog docs: fix use of WDIOC_SETOPTIONS ioctl
From: James Hogan <james@albanarts.com>

In the watchdog-test program and watchdog-api.txt, pass the values to the
WDIOC_SETOPTIONS ioctl as a pointer to an integer containing the values
intead of directly in the third ioctl argument.  The actual watchdog
drivers in drivers/watchdog don't read the options directly from the
argument but use get_user and copy_from_user.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/watchdog/src/watchdog-test.c |    8 ++++++--
 Documentation/watchdog/watchdog-api.txt    |    5 ++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN Documentation/watchdog/src/watchdog-test.c~watchdog-docs-fix-use-of-wdioc_setoptions-ioctl Documentation/watchdog/src/watchdog-test.c
--- a/Documentation/watchdog/src/watchdog-test.c~watchdog-docs-fix-use-of-wdioc_setoptions-ioctl
+++ a/Documentation/watchdog/src/watchdog-test.c
@@ -31,6 +31,8 @@ static void keep_alive(void)
  */
 int main(int argc, char *argv[])
 {
+    int flags;
+
     fd = open("/dev/watchdog", O_WRONLY);
 
     if (fd == -1) {
@@ -41,12 +43,14 @@ int main(int argc, char *argv[])
 
     if (argc > 1) {
 	if (!strncasecmp(argv[1], "-d", 2)) {
-	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_DISABLECARD);
+	    flags = WDIOS_DISABLECARD;
+	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card disabled.\n");
 	    fflush(stderr);
 	    exit(0);
 	} else if (!strncasecmp(argv[1], "-e", 2)) {
-	    ioctl(fd, WDIOC_SETOPTIONS, WDIOS_ENABLECARD);
+	    flags = WDIOS_ENABLECARD;
+	    ioctl(fd, WDIOC_SETOPTIONS, &flags);
 	    fprintf(stderr, "Watchdog card enabled.\n");
 	    fflush(stderr);
 	    exit(0);
diff -puN Documentation/watchdog/watchdog-api.txt~watchdog-docs-fix-use-of-wdioc_setoptions-ioctl Documentation/watchdog/watchdog-api.txt
--- a/Documentation/watchdog/watchdog-api.txt~watchdog-docs-fix-use-of-wdioc_setoptions-ioctl
+++ a/Documentation/watchdog/watchdog-api.txt
@@ -222,11 +222,10 @@ returned value is the temperature in deg
     ioctl(fd, WDIOC_GETTEMP, &temperature);
 
 Finally the SETOPTIONS ioctl can be used to control some aspects of
-the cards operation; right now the pcwd driver is the only one
-supporting this ioctl.
+the cards operation.
 
     int options = 0;
-    ioctl(fd, WDIOC_SETOPTIONS, options);
+    ioctl(fd, WDIOC_SETOPTIONS, &options);
 
 The following options are available:
 
_

Patches currently in -mm which might be from james@albanarts.com are

watchdog-docs-fix-use-of-wdioc_setoptions-ioctl.patch

