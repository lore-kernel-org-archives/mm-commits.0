From: akpm@linux-foundation.org
Subject: [patch 07/21] test_kmod: fix small memory leak on filesystem
 tests
Date: Thu, 10 Aug 2017 15:23:50 -0700
Message-ID: <598cdcf6.mkCwDsqv32X71qyJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48294 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753367AbdHJWXv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dan.carpenter@oracle.com, colin.king@canonical.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, mbenes@suse.cz, mcgrof@kernel.org, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: test_kmod: fix small memory leak on filesystem tests

The break was in the wrong place so file system tests don't work as
intended, leaking memory at each test switch.

[mcgrof@kernel.org: massaged commit subject, noted memory leak issue without the fix]
Link: http://lkml.kernel.org/r/20170802211450.27928-6-mcgrof@kernel.org
Fixes: 39258f448d71 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: David Binderman <dcb314@hotmail.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jessica Yu <jeyu@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kmod.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/test_kmod.c~test_kmod-fix-small-memory-leak-on-filesystem-tests lib/test_kmod.c
--- a/lib/test_kmod.c~test_kmod-fix-small-memory-leak-on-filesystem-tests
+++ a/lib/test_kmod.c
@@ -746,11 +746,11 @@ static int trigger_config_run_type(struc
 						      strlen(test_str));
 		break;
 	case TEST_KMOD_FS_TYPE:
-		break;
 		kfree_const(config->test_fs);
 		config->test_driver = NULL;
 		copied = config_copy_test_fs(config, test_str,
 					     strlen(test_str));
+		break;
 	default:
 		mutex_unlock(&test_dev->config_mutex);
 		return -EINVAL;
_
