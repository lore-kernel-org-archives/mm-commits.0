From: akpm@linux-foundation.org
Subject: [patch 05/21] test_kmod: fix bug which allows negative values on
 two config options
Date: Thu, 10 Aug 2017 15:23:44 -0700
Message-ID: <598cdcf0.3ephc2mhQNCI6XNt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753089AbdHJWXp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mcgrof@kernel.org, colin.king@canonical.com, dan.carpenter@oracle.com, dcb314@hotmail.com, dmitry.torokhov@gmail.com, ebiederm@xmission.com, jeyu@redhat.com, jpoimboe@redhat.com, keescook@chromium.org, mbenes@suse.cz, mmarek@suse.com, pmladek@suse.com, rusty@rustcorp.com.au, shuah@kernel.org

From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: test_kmod: fix bug which allows negative values on two config options

Parsing with kstrtol() enables values to be negative, and we failed to
check for negative values when parsing with either
test_dev_config_update_uint_sync() or test_dev_config_update_uint_range().

test_dev_config_update_uint_range() has a minimum check though so an issue
is not present there.  test_dev_config_update_uint_sync() is only used for
the number of threads to use (config_num_threads_store()), and indeed this
would fail with an attempt for a large allocation.

Although the issue is only present in practice with the first fix both by
using kstrtoul() instead of kstrtol().

Link: http://lkml.kernel.org/r/20170802211450.27928-4-mcgrof@kernel.org
Fixes: 39258f448d71 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: David Binderman <dcb314@hotmail.com>
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

 lib/test_kmod.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/test_kmod.c~test_kmod-fix-bug-which-allows-negative-values-on-two-config-options lib/test_kmod.c
--- a/lib/test_kmod.c~test_kmod-fix-bug-which-allows-negative-values-on-two-config-options
+++ a/lib/test_kmod.c
@@ -880,10 +880,10 @@ static int test_dev_config_update_uint_s
 					    int (*test_sync)(struct kmod_test_device *test_dev))
 {
 	int ret;
-	long new;
+	unsigned long new;
 	unsigned int old_val;
 
-	ret = kstrtol(buf, 10, &new);
+	ret = kstrtoul(buf, 10, &new);
 	if (ret)
 		return ret;
 
@@ -918,9 +918,9 @@ static int test_dev_config_update_uint_r
 					     unsigned int max)
 {
 	int ret;
-	long new;
+	unsigned long new;
 
-	ret = kstrtol(buf, 10, &new);
+	ret = kstrtoul(buf, 10, &new);
 	if (ret)
 		return ret;
 
_
