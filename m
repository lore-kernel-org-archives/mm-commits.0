From: akpm@osdl.org
Subject: + md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:59:46 -0800
Message-ID: <200701240659.l0O6xkWv010975@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54895 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177AbXAXG7y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: make sure the events count in an md array never returns to zero
has been added to the -mm tree.  Its filename is
     md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: make sure the events count in an md array never returns to zero
From: NeilBrown <neilb@suse.de>

Now that we sometimes step the array events count backwards (when
transitioning dirty->clean where nothing else interesting has happened - so
that we don't need to write to spares all the time), it is possible for the
event count to return to zero, which is potentially confusing and triggers and
MD_BUG.

We could possibly remove the MD_BUG, but is just as easy, and probably safer,
to make sure we never return to zero.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero drivers/md/md.c
--- a/drivers/md/md.c~md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero
+++ a/drivers/md/md.c
@@ -1633,7 +1633,8 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
-	    && (mddev->events & 1))
+	    && (mddev->events & 1)
+	    && mddev->events != 1)
 		mddev->events--;
 	else {
 		/* otherwise we have to go forward and ... */
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
md-update-email-address-and-status-for-md-in-maintainers.patch
md-make-repair-actually-work-for-raid1.patch
md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch
md-avoid-reading-past-the-end-of-a-bitmap-file.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
