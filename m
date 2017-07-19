From: akpm@linux-foundation.org
Subject: + fscache-fix-fscache_objlist_show-format-processing.patch added
 to -mm tree
Date: Wed, 19 Jul 2017 14:50:36 -0700
Message-ID: <596fd42c.OL/ClAsbCLYhj8Jg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34146 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755127AbdGSVuh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fscache: fix fscache_objlist_show format processing
has been added to the -mm tree.  Its filename is
     fscache-fix-fscache_objlist_show-format-processing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fscache-fix-fscache_objlist_show-format-processing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fscache-fix-fscache_objlist_show-format-processing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fscache: fix fscache_objlist_show format processing

gcc points out a minor bug in the handling of unknown
cookie types, which could result in a string overflow
when the integer is copied into a 3-byte string:

fs/fscache/object-list.c: In function 'fscache_objlist_show':
fs/fscache/object-list.c:265:19: error: 'sprintf' may write a terminating nul past the end of the destination [-Werror=format-overflow=]
 sprintf(_type, "%02u", cookie->def->type);
                ^~~~~~
fs/fscache/object-list.c:265:4: note: 'sprintf' output between 3 and 4 bytes into a destination of size 3

This is currently harmless as no code sets a type other
than 0 or 1, but it makes sense to use snprintf() here
to avoid overflowing the array if that changes.

Link: http://lkml.kernel.org/r/20170714120720.906842-22-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fscache/object-list.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fscache/object-list.c~fscache-fix-fscache_objlist_show-format-processing fs/fscache/object-list.c
--- a/fs/fscache/object-list.c~fscache-fix-fscache_objlist_show-format-processing
+++ a/fs/fscache/object-list.c
@@ -262,7 +262,8 @@ static int fscache_objlist_show(struct s
 			type = "DT";
 			break;
 		default:
-			sprintf(_type, "%02u", cookie->def->type);
+			snprintf(_type, sizeof(_type), "%02u",
+				 cookie->def->type);
 			type = _type;
 			break;
 		}
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

