From: akpm@linux-foundation.org
Subject: [merged] uapi-strip-the-_uapi-prefix-from-header-guards-during-header-installation.patch removed from -mm tree
Date: Fri, 30 Nov 2012 13:28:21 -0800
Message-ID: <20121130212821.E4F52100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:44782 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2K3V2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Nov 2012 16:28:23 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so102732yen.1
        for <mm-commits@vger.kernel.org>; Fri, 30 Nov 2012 13:28:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jwboyer@redhat.com, tomek@pipebreaker.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: UAPI: strip the _UAPI prefix from header guards during header installation
has been removed from the -mm tree.  Its filename was
     uapi-strip-the-_uapi-prefix-from-header-guards-during-header-installation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: UAPI: strip the _UAPI prefix from header guards during header installation

Strip the _UAPI prefix from header guards during header installation so
that any userspace dependencies aren't affected.  glibc, for example,
checks for linux/types.h, linux/kernel.h, linux/compiler.h and
linux/list.h by their guards - though the last two aren't actually
exported.

	libtool: compile:  gcc -std=gnu99 -DHAVE_CONFIG_H -I. -Wall -Werror -Wformat -Wformat-security -D_FORTIFY_SOURCE=2 -fno-delete-null-pointer-checks -fstack-protector -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i686 -mtune=atom -fasynchronous-unwind-tables -c child.c  -fPIC -DPIC -o .libs/child.o
	In file included from cli.c:20:0:
	common.h:152:8: error: redefinition of 'struct sysinfo'
	In file included from /usr/include/linux/kernel.h:4:0,
			 from /usr/include/linux/sysctl.h:25,
			 from /usr/include/sys/sysctl.h:43,
			 from common.h:50,
			 from cli.c:20:
	/usr/include/linux/sysinfo.h:7:8: note: originally defined here

Reported-by: Tomasz Torcz <tomek@pipebreaker.pl>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_install.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/headers_install.pl~uapi-strip-the-_uapi-prefix-from-header-guards-during-header-installation scripts/headers_install.pl
--- a/scripts/headers_install.pl~uapi-strip-the-_uapi-prefix-from-header-guards-during-header-installation
+++ a/scripts/headers_install.pl
@@ -42,6 +42,9 @@ foreach my $filename (@files) {
 		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
 		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
 		$line =~ s/(^|\s|[(])(volatile)\b(\s|[(]|$)/$1__$2__$3/g;
+		$line =~ s/#ifndef _UAPI/#ifndef /;
+		$line =~ s/#define _UAPI/#define /;
+		$line =~ s!#endif /[*] _UAPI!#endif /* !;
 		printf {$out} "%s", $line;
 	}
 	close $out;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
wait-add-wait_event_lock_irq-interface.patch
loop-limit-the-number-of-requests-in-the-bio-list.patch
ptrace-introduce-ptrace_o_exitkill.patch
pidns-remove-unused-is_container_init.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

