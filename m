From: akpm@linux-foundation.org
Subject: +
 modpost-dont-add-a-trailing-wildcard-for-of-module-aliases.patch added to
 -mm tree
Date: Tue, 08 Dec 2015 15:09:39 -0800
Message-ID: <56676333.uuzkr3oN33goG6PB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbbLHXJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:09:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier@osg.samsung.com, computersforpeace@gmail.com, rusty@rustcorp.com.au, sjoerd.simons@collabora.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: modpost: don't add a trailing wildcard for OF module aliases
has been added to the -mm tree.  Its filename is
     modpost-dont-add-a-trailing-wildcard-for-of-module-aliases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/modpost-dont-add-a-trailing-wildcard-for-of-module-aliases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/modpost-dont-add-a-trailing-wildcard-for-of-module-aliases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: modpost: don't add a trailing wildcard for OF module aliases

Commit ac551828993ee ("modpost: i2c aliases need no trailing wildcard")
removed the wildcard at the end of the I2C module aliases because I2C
devices have no IDs so the aliases are just arbitrary device names.

This is also true for OF modaliases since a compatible string is used to
define a specific IP hardware block.  So the modalias should match a
specific compatible string and not attempt to match a compatible string
whose name matches the beginning of another one.

For example, the following driver module:

$ modinfo cros_ec_keyb | grep alias
alias:          platform:cros-ec-keyb
alias:          of:N*T*Cgoogle,cros-ec-keyb*

will be tried to be loaded for an alias of:N*T*Cgoogle,cros-ec-keyb-v2 but
there could be a different driver that supports the device for that
compatible string so it's better to remove the trailing wildcard for OF.

Also, remove the word "always" from the add_wildcard() function comment
since that was carried from the time where a wildcard was always added at
the end of the module alias for all the devices.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Suggested-by: Brian Norris <computersforpeace@gmail.com>
Reviewed-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/file2alias.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN scripts/mod/file2alias.c~modpost-dont-add-a-trailing-wildcard-for-of-module-aliases scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~modpost-dont-add-a-trailing-wildcard-for-of-module-aliases
+++ a/scripts/mod/file2alias.c
@@ -125,7 +125,7 @@ do {
                 sprintf(str + strlen(str), "*");                \
 } while(0)
 
-/* Always end in a wildcard, for future extension */
+/* End in a wildcard, for future extension */
 static inline void add_wildcard(char *str)
 {
 	int len = strlen(str);
@@ -704,7 +704,6 @@ static int do_of_entry (const char *file
 		if (isspace (*tmp))
 			*tmp = '_';
 
-	add_wildcard(alias);
 	return 1;
 }
 ADD_TO_DEVTABLE("of", of_device_id, do_of_entry);
_

Patches currently in -mm which might be from javier@osg.samsung.com are

modpost-dont-add-a-trailing-wildcard-for-of-module-aliases.patch

