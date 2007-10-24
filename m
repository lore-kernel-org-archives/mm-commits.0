From: akpm@linux-foundation.org
Subject: - documentation-watchdog-src-watchdog-simplec-improve-this-code.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:27 -0700
Message-ID: <200710242141.l9OLfRu2013956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756646AbXJXVlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:41:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Documentation/watchdog/src/watchdog-simple.c: improve this code
has been removed from the -mm tree.  Its filename was
     documentation-watchdog-src-watchdog-simplec-improve-this-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation/watchdog/src/watchdog-simple.c: improve this code
From: WANG Cong <xiyou.wangcong@gmail.com>

Make some improvements for Documentation/watchdog/src/watchdog-simple.c.

Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/watchdog/src/watchdog-simple.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff -puN Documentation/watchdog/src/watchdog-simple.c~documentation-watchdog-src-watchdog-simplec-improve-this-code Documentation/watchdog/src/watchdog-simple.c
--- a/Documentation/watchdog/src/watchdog-simple.c~documentation-watchdog-src-watchdog-simplec-improve-this-code
+++ a/Documentation/watchdog/src/watchdog-simple.c
@@ -3,15 +3,24 @@
 #include <unistd.h>
 #include <fcntl.h>
 
-int main(int argc, const char *argv[]) {
+int main(void) {
 	int fd = open("/dev/watchdog", O_WRONLY);
+	int ret = 0;
 	if (fd == -1) {
 		perror("watchdog");
-		exit(1);
+		exit(EXIT_FAILURE);
 	}
 	while (1) {
-		write(fd, "\0", 1);
-		fsync(fd);
+		ret = write(fd, "\0", 1);
+		if (ret != 1) {
+			ret = -1;
+			break;
+		}
+		ret = fsync(fd);
+		if (ret)
+			break;
 		sleep(10);
 	}
+	close(fd);
+	return ret;
 }
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

git-watchdog.patch
