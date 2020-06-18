From: akpm@linux-foundation.org
Subject: +
 test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch added
 to -mm tree
Date: Wed, 17 Jun 2020 17:48:43 -0700
Message-ID: <20200618004843.6QhTL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgFRAso (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 20:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, slyfox@gentoo.org, shuah@kernel.org, serge@hallyn.com, roopa@cumulusnetworks.com, ravenexp@gmail.com, philipp.reisner@linbit.com, nikolay@cumulusnetworks.com, mcgrof@kernel.org, lars.ellenberg@linbit.com, kuba@kernel.org, keescook@chromium.org, josh@joshtriplett.org, jmorris@namei.org, jarkko.sakkinen@linux.intel.com, gregkh@linuxfoundation.org, dhowells@redhat.com, davem@davemloft.net, chuck.lever@oracle.com, christian.brauner@ubuntu.com, chainsaw@gentoo.org, bfields@fieldses.org, axboe@kernel.dk, ast@kernel.org, yangtiezhu@loongson.cn


The patch titled
     Subject: test_kmod: avoid potential double free in trigger_config_run_type()
has been added to the -mm tree.  Its filename is
     test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: test_kmod: avoid potential double free in trigger_config_run_type()

Reset the member "test_fs" of the test configuration after a call of the
function "kfree_const" to a null pointer so that a double memory release
will not be performed.

Link: http://lkml.kernel.org/r/20200610154923.27510-4-mcgrof@kernel.org
Fixes: d9c6a72d6fa2 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Vroon <chainsaw@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_kmod.c~test_kmod-avoid-potential-double-free-in-trigger_config_run_type
+++ a/lib/test_kmod.c
@@ -745,7 +745,7 @@ static int trigger_config_run_type(struc
 		break;
 	case TEST_KMOD_FS_TYPE:
 		kfree_const(config->test_fs);
-		config->test_driver = NULL;
+		config->test_fs = NULL;
 		copied = config_copy_test_fs(config, test_str,
 					     strlen(test_str));
 		break;
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-kmod-use-variable-name-in-kmod_test_0001.patch
kmod-remove-redundant-be-an-in-the-comment.patch
test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
