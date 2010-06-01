From: akpm@linux-foundation.org
Subject: + gconfig-fix-build-failure-on-fedora-13.patch added to -mm tree
Date: Tue, 01 Jun 2010 15:54:54 -0700
Message-ID: <201006012254.o51MssTC023693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab0FAWzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 18:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, mmarek@suse.cz, stable@kernel.org, xiyou.wangcong@gmail.com


The patch titled
     gconfig: fix build failure on fedora 13
has been added to the -mm tree.  Its filename is
     gconfig-fix-build-failure-on-fedora-13.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gconfig: fix build failure on fedora 13
From: Richard Kennedy <richard@rsk.demon.co.uk>

Making gconfig fails on fedora 13 as the linker cannot resolve dlsym.

Adding libdl to the link command fixes this.

make shows this error :-
    /usr/bin/ld: scripts/kconfig/kconfig_load.o: undefined reference to symbol 'dlsym@@GLIBC_2.2.5'
    /usr/bin/ld: note: 'dlsym@@GLIBC_2.2.5' is defined in DSO /lib64/libdl.so.2 so try adding it to the linker command line
    /lib64/libdl.so.2: could not read symbols: Invalid operation

tested on x86_64 fedora 13.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/Makefile~gconfig-fix-build-failure-on-fedora-13 scripts/kconfig/Makefile
--- a/scripts/kconfig/Makefile~gconfig-fix-build-failure-on-fedora-13
+++ a/scripts/kconfig/Makefile
@@ -219,7 +219,7 @@ HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
 HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
+HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0` -ldl
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -D LKC_DIRECT_LINK
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

gconfig-fix-build-failure-on-fedora-13.patch
buffer_head-remove-redundant-test-from-wait_on_buffer.patch
buffer_head-remove-redundant-test-from-wait_on_buffer-fix.patch
wait_on_buffer-remove-the-buffer_locked-test.patch

