From: akpm@linux-foundation.org
Subject: [alternative-merged]
 get_maintainer-handle-file-names-beginning-with.patch removed from -mm tree
Date: Mon, 11 Jan 2016 20:31:12 -0800
Message-ID: <56948190.S7vBaREMDzzqopc6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761543AbcALEbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jan 2016 23:31:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: handle file names beginning with ./
has been removed from the -mm tree.  Its filename was
     get_maintainer-handle-file-names-beginning-with.patch

This patch was dropped because an alternative patch was merged

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
c6x-convert-to-dma_map_ops-fix.patch
maintainers-fix-mic-maintainers-entry.patch

