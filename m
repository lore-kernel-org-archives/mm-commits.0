From: akpm@osdl.org
Subject: + md-make-repair-actually-work-for-raid1.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:59:44 -0800
Message-ID: <200701240659.l0O6xi61010972@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177AbXAXHAh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: make 'repair' actually work for raid1
has been added to the -mm tree.  Its filename is
     md-make-repair-actually-work-for-raid1.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: make 'repair' actually work for raid1
From: NeilBrown <neilb@suse.de>

When 'repair' finds a block that is different one the various parts of the
mirror.  it is meant to write a chosen good version to the others.  However it
currently writes out the original data to each.  The memcpy to make all the
data the same is missing.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/raid1.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/md/raid1.c~md-make-repair-actually-work-for-raid1 drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-make-repair-actually-work-for-raid1
+++ a/drivers/md/raid1.c
@@ -1266,6 +1266,11 @@ static void sync_request_write(mddev_t *
 					sbio->bi_sector = r1_bio->sector +
 						conf->mirrors[i].rdev->data_offset;
 					sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+					for (j = 0; j < vcnt ; j++)
+						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
+						       page_address(pbio->bi_io_vec[j].bv_page),
+						       PAGE_SIZE);
+
 				}
 			}
 	}
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
