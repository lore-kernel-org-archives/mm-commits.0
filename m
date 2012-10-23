From: akpm@linux-foundation.org
Subject: + pidns-limit-the-nesting-depth-of-pid-namespaces.patch added to -mm tree
Date: Tue, 23 Oct 2012 16:57:01 -0700
Message-ID: <20121023235702.9E39F200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57602 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWX5F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 19:57:05 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so263209eek.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 16:57:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, oleg@redhat.com, xemul@parallels.com


The patch titled
     Subject: pidns: limit the nesting depth of pid namespaces
has been added to the -mm tree.  Its filename is
     pidns-limit-the-nesting-depth-of-pid-namespaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Vagin <avagin@openvz.org>
Subject: pidns: limit the nesting depth of pid namespaces

'struct pid' is a "variable sized struct" - a header with an array of
upids at the end.

The size of the array depends on a level (depth) of pid namespaces.  Now a
level of pidns is not limited, so 'struct pid' can be more than one page.

Looks reasonable, that it should be less than a page.  MAX_PIS_NS_LEVEL is
not calculated from PAGE_SIZE, because in this case it depends on
architectures, config options and it will be reduced, if someone adds a
new fields in struct pid or struct upid.

I suggest to set MAX_PIS_NS_LEVEL = 32, because it saves ability to expand
"struct pid" and it's more than enough for all known for me use-cases. 
When someone finds a reasonable use case, we can add a config option or a
sysctl parameter.

In addition it will reduce the effect of another problem, when we have
many nested namespaces and the oldest one starts dying. 
zap_pid_ns_processe will be called for each namespace and find_vpid will
be called for each process in a namespace.  find_vpid will be called
minimum max_level^2 / 2 times.  The reason of that is that when we found a
bit in pidmap, we can't determine this pidns is top for this process or it
isn't.

vpid is a heavy operation, so a fork bomb, which create many nested
namespace, can make a system inaccessible for a long time.  For example my
system becomes inaccessible for a few minutes with 4000 processes.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces
+++ a/kernel/pid_namespace.c
@@ -71,12 +71,18 @@ err_alloc:
 	return NULL;
 }
 
+/* MAX_PID_NS_LEVEL is needed for limiting size of 'struct pid' */
+#define MAX_PID_NS_LEVEL 32
+
 static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
 	int i, err = -ENOMEM;
 
+	if (level > MAX_PID_NS_LEVEL)
+		goto out;
+
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
_

Patches currently in -mm which might be from avagin@openvz.org are

pidns-limit-the-nesting-depth-of-pid-namespaces.patch
pidns-limit-the-nesting-depth-of-pid-namespaces-fix.patch
proc-dont-show-nonexistent-capabilities.patch

