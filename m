From: akpm@linux-foundation.org
Subject: +
 gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch added to -mm tree
Date: Mon, 04 Nov 2013 13:12:11 -0800
Message-ID: <52780dab.xBYmK5cwg59A6h+E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KDVMM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Nov 2013 16:12:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, jkosina@suse.cz, jj@codesealer.com, mina86@mina86.com

Subject: + gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch added to -mm tree
To: mina86@mina86.com,jj@codesealer.com,jkosina@suse.cz,keescook@chromium.org
From: akpm@linux-foundation.org
Date: Mon, 04 Nov 2013 13:12:11 -0800


The patch titled
     Subject: gen_init_cpio: avoid NULL pointer dereference and rework env expanding
has been added to the -mm tree.  Its filename is
     gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: gen_init_cpio: avoid NULL pointer dereference and rework env expanding

getenv() may return NULL if given environment variable does not exist
which leads to NULL dereference when calling strncat.

Besides that, the environment variable name was copied to a temporary
env_var buffer, but this copying can be avoided by simply using the input
string.

Lastly, the whole loop can be greatly simplified by using the snprintf
function instead of the playing with strncat.

 By the way, the current implementation allows a recursive variable
 expansion, as in:

   $ echo 'out ${A} out ' | A='a ${B} a' B=b /tmp/a
   out a b a out

 I'm assuming this is just a side effect and not a conscious decision
 (especially as this may lead to infinite loop), but I didn't want to
 change this behaviour without consulting.

 If the current behaviour is deamed incorrect, I'll be happy to send
 a patch without recursive processing.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jesper Juhl <jj@codesealer.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/gen_init_cpio.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN usr/gen_init_cpio.c~gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding usr/gen_init_cpio.c
--- a/usr/gen_init_cpio.c~gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding
+++ a/usr/gen_init_cpio.c
@@ -382,24 +382,15 @@ error:
 static char *cpio_replace_env(char *new_location)
 {
 	char expanded[PATH_MAX + 1];
-	char env_var[PATH_MAX + 1];
-	char *start;
-	char *end;
+	char *start, *end, *var;
 
-	for (start = NULL; (start = strstr(new_location, "${")); ) {
-		end = strchr(start, '}');
-		if (start < end) {
-			*env_var = *expanded = '\0';
-			strncat(env_var, start + 2, end - start - 2);
-			strncat(expanded, new_location, start - new_location);
-			strncat(expanded, getenv(env_var),
-				PATH_MAX - strlen(expanded));
-			strncat(expanded, end + 1,
-				PATH_MAX - strlen(expanded));
-			strncpy(new_location, expanded, PATH_MAX);
-			new_location[PATH_MAX] = 0;
-		} else
-			break;
+	while ((start = strstr(new_location, "${")) &&
+	       (end = strchr(start + 2, '}'))) {
+		*start = *end = 0;
+		var = getenv(start + 2);
+		snprintf(expanded, sizeof expanded, "%s%s%s",
+			 new_location, var ? var : "", end + 1);
+		strcpy(new_location, expanded);
 	}
 
 	return new_location;
_

Patches currently in -mm which might be from mina86@mina86.com are

memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
mm-__rmqueue_fallback-should-respect-pageblock-type.patch
gen_init_cpio-avoid-null-pointer-dereference-and-rework-env-expanding.patch
drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch
drivers-w1-make-w1_slave-flags-long-to-avoid-casts.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

