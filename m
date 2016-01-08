From: akpm@linux-foundation.org
Subject: + get_maintainer-handle-file-names-beginning-with.patch
 tentatively added to -mm tree
Date: Fri, 08 Jan 2016 14:46:23 -0800
Message-ID: <56903c3f.nvHWVkBxx22S6FdA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbcAHWqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 17:46:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: handle file names beginning with ./
has been added to the -mm tree.  Its filename is
     get_maintainer-handle-file-names-beginning-with.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-handle-file-names-beginning-with.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-handle-file-names-beginning-with.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: get_maintainer: handle file names beginning with ./

The problem is that get_maintainer.pl doesn't work if you have a ./
prefix on the filename.  For example, if you type:

    ./scripts/get_maintainer.pl -f ./drivers/usb/usb-skeleton.c

then the current code only includes LKML and people from the git log, it
doesn't include Greg or the linux-usb list.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/get_maintainer.pl~get_maintainer-handle-file-names-beginning-with scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-handle-file-names-beginning-with
+++ a/scripts/get_maintainer.pl
@@ -605,6 +605,8 @@ sub get_maintainers {
 
     foreach my $file (@files) {
 
+	$file =~ s/^\.\///;
+
 	my %hash;
 	my $tvi = find_first_section();
 	while ($tvi < @typevalue) {
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-add-tracepoint-for-scanning-pages-fix.patch
get_maintainer-handle-file-names-beginning-with.patch
c6x-convert-to-dma_map_ops-fix.patch
maintainers-fix-mic-maintainers-entry.patch

