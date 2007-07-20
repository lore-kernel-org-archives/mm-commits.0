From: akpm@linux-foundation.org
Subject: - containersv10-basic-container-framework-fix-3.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:28:55 -0700
Message-ID: <200707202028.l6KKStVg014837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757674AbXGTU3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:29:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhaval@linux.vnet.ibm.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     containersv10-basic-container-framework-fix-3
has been removed from the -mm tree.  Its filename was
     containersv10-basic-container-framework-fix-3.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: containersv10-basic-container-framework-fix-3
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Hi,

On Tue, May 29, 2007 at 06:01:05AM -0700, menage@google.com wrote:
> +1.5 How do I use containers ?
> +--------------------------
> +
> +To start a new job that is to be contained within a container, using
> +the "cpuset" container subsystem, the steps are something like:
> +
> + 1) mkdir /dev/container
> + 2) mount -t container -ocpuset cpuset /dev/container
> + 3) Create the new container by doing mkdir's and write's (or echo's) in
> +    the /dev/container virtual file system.
> + 4) Start a task that will be the "founding father" of the new job.
> + 5) Attach that task to the new container by writing its pid to the
> +    /dev/container tasks file for that container.
> + 6) fork, exec or clone the job tasks from this founding father task.
> +
> +For example, the following sequence of commands will setup a container
> +named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
> +and then start a subshell 'sh' in that container:
> +
> +  mount -t container cpuset -ocpuset /dev/container
> +  cd /dev/container
> +  mkdir Charlie
> +  cd Charlie

This example does not work. To do so we need to do

  /bin/echo 2-3 > cpus
  /bin/echo 1 > mems

> +  /bin/echo $$ > tasks
> +  sh
> +  # The subshell 'sh' is now running in container Charlie
> +  # The next line should display '/Charlie'
> +  cat /proc/self/container

The following patch does that.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/containers.txt |    2 ++
 1 files changed, 2 insertions(+)

diff -puN Documentation/containers.txt~containersv10-basic-container-framework-fix-3 Documentation/containers.txt
--- a/Documentation/containers.txt~containersv10-basic-container-framework-fix-3
+++ a/Documentation/containers.txt
@@ -298,6 +298,8 @@ and then start a subshell 'sh' in that c
   cd /dev/container
   mkdir Charlie
   cd Charlie
+  /bin/echo 2-3 > cpus
+  /bin/echo 1 > mems
   /bin/echo $$ > tasks
   sh
   # The subshell 'sh' is now running in container Charlie
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com are

containersv10-basic-container-framework-fix-3.patch
containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch
