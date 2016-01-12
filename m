From: akpm@linux-foundation.org
Subject: + scripts-get_maintainerpl-handle-file-names-beginning-with.patch added to -mm tree
Date: Mon, 11 Jan 2016 20:31:22 -0800
Message-ID: <5694819a.Lby70r+9jEPmZT0B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761579AbcALEbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 23:31:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/get_maintainer.pl: handle file names beginning with ./
has been added to the -mm tree.  Its filename is
     scripts-get_maintainerpl-handle-file-names-beginning-with.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-get_maintainerpl-handle-file-names-beginning-with.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-get_maintainerpl-handle-file-names-beginning-with.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: scripts/get_maintainer.pl: handle file names beginning with ./

The problem is that get_maintainer.pl doesn't work if you have a ./
prefix on the filename.  For example, if you type:

    ./scripts/get_maintainer.pl -f ./drivers/usb/usb-skeleton.c

then the current code only includes LKML and people from the git log, it
doesn't include Greg or the linux-usb list.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/get_maintainer.pl~scripts-get_maintainerpl-handle-file-names-beginning-with scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~scripts-get_maintainerpl-handle-file-names-beginning-with
+++ a/scripts/get_maintainer.pl
@@ -16,7 +16,9 @@ my $P = $0;
 my $V = '0.26';
 
 use Getopt::Long qw(:config no_auto_abbrev);
+use Cwd;
 
+my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
 my $email = 1;
 my $email_usename = 1;
@@ -429,6 +431,8 @@ foreach my $file (@ARGV) {
 	}
     }
     if ($from_filename) {
+	$file =~ s/^\Q${cur_path}\E//;	#strip any absolute path
+	$file =~ s/^\Q${lk_path}\E//;	#or the path to the lk tree
 	push(@files, $file);
 	if ($file ne "MAINTAINERS" && -f $file && ($keywords || $file_emails)) {
 	    open(my $f, '<', $file)
_

Patches currently in -mm which might be from joe@perches.com are

scripts-get_maintainerpl-handle-file-names-beginning-with.patch
checkpatch-warn-when-casting-constants-to-c90-int-or-longer-types.patch
checkpatch-improve-macros-with-flow-control-test.patch

