From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?get=5Fmaintainer-fix-unexpected-behavior-for-path-to-file-?=
 =?US-ASCII?Q?double-slashes.patch?= removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:01 -0700
Message-ID: <20200605201901.grUrqoTKR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFEUTC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: emil.l.velikov@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: fix unexpected behavior for path/to//file (double slashes)
has been removed from the -mm tree.  Its filename was
     get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: fix unexpected behavior for path/to//file (double slashes)

get_maintainer behaves differently if there is a double sequential forward
slash in a filename because the total number of slashes in a filename is
used to match MAINTAINERS file patterns.

For example:

# (with double slash)
$ ./scripts/get_maintainer.pl -f drivers/gpu/drm//lima
David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS,commit_signer:3/42=7%)
Qiang Yu <yuq825@gmail.com> (commit_signer:36/42=86%,authored:24/42=57%)
Vasily Khoruzhick <anarsoul@gmail.com> (commit_signer:26/42=62%)
Krzysztof Kozlowski <krzk@kernel.org> (commit_signer:5/42=12%,authored:5/42=12%)
Emil Velikov <emil.velikov@collabora.com> (commit_signer:4/42=10%)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
linux-kernel@vger.kernel.org (open list)

# (without double slash)
$ ./scripts/get_maintainer.pl -f drivers/gpu/drm/lima
Qiang Yu <yuq825@gmail.com> (maintainer:DRM DRIVERS FOR LIMA)
David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
Daniel Vetter <daniel@ffwll.ch> (maintainer:DRM DRIVERS)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR LIMA)
lima@lists.freedesktop.org (moderated list:DRM DRIVERS FOR LIMA)
linux-kernel@vger.kernel.org (open list)

So reduce consecutive double slashes to a single slash
by using File::Spec->canonpath().

from: https://perldoc.perl.org/File/Spec/Unix.html

canonpath()

No physical check on the filesystem, but a logical cleanup of a path.  On
UNIX eliminates successive slashes and successive "/.".

Link: http://lkml.kernel.org/r/9a18b611813bb409fef15bc8927adab79eb9be43.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/get_maintainer.pl~get_maintainer-fix-unexpected-behavior-for-path-to-file-double-slashes
+++ a/scripts/get_maintainer.pl
@@ -19,6 +19,7 @@ my $V = '0.26';
 use Getopt::Long qw(:config no_auto_abbrev);
 use Cwd;
 use File::Find;
+use File::Spec::Functions;
 
 my $cur_path = fastgetcwd() . '/';
 my $lk_path = "./";
@@ -532,6 +533,7 @@ if (!@ARGV) {
 
 foreach my $file (@ARGV) {
     if ($file ne "&STDIN") {
+	$file = canonpath($file);
 	##if $file is a directory and it lacks a trailing slash, add one
 	if ((-d $file)) {
 	    $file =~ s@([^/])$@$1/@;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
