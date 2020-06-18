From: akpm@linux-foundation.org
Subject: + selftests-kmod-use-variable-name-in-kmod_test_0001.patch
 added to -mm tree
Date: Wed, 17 Jun 2020 17:48:37 -0700
Message-ID: <20200618004837.NWFQ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgFRAsj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 20:48:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, slyfox@gentoo.org, shuah@kernel.org, serge@hallyn.com, roopa@cumulusnetworks.com, ravenexp@gmail.com, philipp.reisner@linbit.com, nikolay@cumulusnetworks.com, mcgrof@kernel.org, lars.ellenberg@linbit.com, kuba@kernel.org, keescook@chromium.org, josh@joshtriplett.org, jmorris@namei.org, jarkko.sakkinen@linux.intel.com, gregkh@linuxfoundation.org, dhowells@redhat.com, davem@davemloft.net, chuck.lever@oracle.com, christian.brauner@ubuntu.com, chainsaw@gentoo.org, bfields@fieldses.org, axboe@kernel.dk, ast@kernel.org, yangtiezhu@loongson.cn


The patch titled
     Subject: selftests: kmod: use variable NAME in kmod_test_0001()
has been added to the -mm tree.  Its filename is
     selftests-kmod-use-variable-name-in-kmod_test_0001.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-kmod-use-variable-name-in-kmod_test_0001.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-kmod-use-variable-name-in-kmod_test_0001.patch

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
Subject: selftests: kmod: use variable NAME in kmod_test_0001()

Patch series "kmod/umh: a few fixes".

Tiezhu Yang had sent out a patch set with a slew of kmod selftest fixes,
and one patch which modified kmod to return 254 when a module was not
found.  This opened up pandora's box about why that was being used for and
low and behold its because when UMH_WAIT_PROC is used we call a
kernel_wait4() call but have never unwrapped the error code.  The commit
log for that fix details the rationale for the approach taken.  I'd
appreciate some review on that, in particular nfs folks as it seems a case
was never really hit before.


This patch (of 5):

Use the variable NAME instead of "\000" directly in kmod_test_0001().

Link: http://lkml.kernel.org/r/20200610154923.27510-1-mcgrof@kernel.org
Link: http://lkml.kernel.org/r/20200610154923.27510-2-mcgrof@kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kmod/kmod.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/kmod/kmod.sh~selftests-kmod-use-variable-name-in-kmod_test_0001
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -341,7 +341,7 @@ kmod_test_0001_driver()
 
 	kmod_defaults_driver
 	config_num_threads 1
-	printf '\000' >"$DIR"/config_test_driver
+	printf $NAME >"$DIR"/config_test_driver
 	config_trigger ${FUNCNAME[0]}
 	config_expect_result ${FUNCNAME[0]} MODULE_NOT_FOUND
 }
@@ -352,7 +352,7 @@ kmod_test_0001_fs()
 
 	kmod_defaults_fs
 	config_num_threads 1
-	printf '\000' >"$DIR"/config_test_fs
+	printf $NAME >"$DIR"/config_test_fs
 	config_trigger ${FUNCNAME[0]}
 	config_expect_result ${FUNCNAME[0]} -EINVAL
 }
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

selftests-kmod-use-variable-name-in-kmod_test_0001.patch
kmod-remove-redundant-be-an-in-the-comment.patch
test_kmod-avoid-potential-double-free-in-trigger_config_run_type.patch
