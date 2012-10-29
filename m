From: akpm@linux-foundation.org
Subject: [merged] pidns-limit-the-nesting-depth-of-pid-namespaces.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:23 -0700
Message-ID: <20121029195023.C0BC7100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:43053 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab2J2TuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:25 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so581602qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, ebiederm@xmission.com, gorcunov@openvz.org, oleg@redhat.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: limit the nesting depth of pid namespaces
has been removed from the -mm tree.  Its filename was
     pidns-limit-the-nesting-depth-of-pid-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: return -EINVAL in response to excessive nesting, not -ENOMEM]
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces
+++ a/kernel/pid_namespace.c
@@ -71,12 +71,22 @@ err_alloc:
 	return NULL;
 }
 
+/* MAX_PID_NS_LEVEL is needed for limiting size of 'struct pid' */
+#define MAX_PID_NS_LEVEL 32
+
 static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
-	int i, err = -ENOMEM;
+	int i;
+	int err;
+
+	if (level > MAX_PID_NS_LEVEL) {
+		err = -EINVAL;
+		goto out;
+	}
 
+	err = -ENOMEM;
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
_

Patches currently in -mm which might be from avagin@openvz.org are

linux-next.patch
proc-dont-show-nonexistent-capabilities.patch

