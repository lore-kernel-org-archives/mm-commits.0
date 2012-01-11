From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-export_symbol-handling-following-a-function.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:22 -0800
Message-ID: <20120111213122.AA53B1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:33196 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2AKVbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:23 -0500
Received: by mail-gy0-f202.google.com with SMTP id r15so137318ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix EXPORT_SYMBOL handling following a function
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-export_symbol-handling-following-a-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: fix EXPORT_SYMBOL handling following a function

The following fragment defeats the DEVICE_ATTR style handing, check for
and ignore the close brace '}' in this context:

    int foo()
    {
    }
    DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
                ata_scsi_lpm_show, ata_scsi_lpm_put);
    EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-export_symbol-handling-following-a-function scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-export_symbol-handling-following-a-function
+++ a/scripts/checkpatch.pl
@@ -2131,7 +2131,7 @@ sub process {
 			#   XXX(foo);
 			#   EXPORT_SYMBOL(something_foo);
 			my $name = $1;
-			if ($stat =~ /^.([A-Z_]+)\s*\(\s*($Ident)/ &&
+			if ($stat =~ /^(?:.\s*}\s*\n)?.([A-Z_]+)\s*\(\s*($Ident)/ &&
 			    $name =~ /^${Ident}_$2/) {
 #print "FOO C name<$name>\n";
 				$suppress_export{$realline_next} = 1;
_

Patches currently in -mm which might be from apw@canonical.com are

origin.patch

