From: akpm@linux-foundation.org
Subject: [patch 004/123] scripts/bloat-o-meter: compile .NUMBER regex
Date: Mon, 12 Dec 2016 16:40:48 -0800
Message-ID: <584f4390.ym8XYkBHBEw5b/zx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40360 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAkt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:40:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: scripts/bloat-o-meter: compile .NUMBER regex

Every often used regex is better be compiled in Python.

Speedup is about ~9.8% (whee!)

	$ perf stat -r 16 taskset -c 15 ./scripts/bloat-o-meter ../vmlinux-000 ../obj/vmlinux >/dev/null
	7.091202853 seconds time elapsed                                          ( +-  0.15% )

	+re.compile
	6.397564973 seconds time elapsed                                          ( +-  0.34% )

Link: http://lkml.kernel.org/r/20161119004417.GB1200@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/bloat-o-meter |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/bloat-o-meter~scripts-bloat-o-meter-compile-number-regex scripts/bloat-o-meter
--- a/scripts/bloat-o-meter~scripts-bloat-o-meter-compile-number-regex
+++ a/scripts/bloat-o-meter
@@ -16,6 +16,8 @@ if len(sys.argv) != 3:
     sys.stderr.write("usage: %s file1 file2\n" % sys.argv[0])
     sys.exit(-1)
 
+re_NUMBER = re.compile(r'\.[0-9]+')
+
 def getsizes(file):
     sym = {}
     with os.popen("nm --size-sort " + file) as f:
@@ -28,7 +30,7 @@ def getsizes(file):
                 if name.startswith("compat_SyS_"): continue
                 if name == "linux_banner": continue
                 # statics and some other optimizations adds random .NUMBER
-                name = re.sub(r'\.[0-9]+', '', name)
+                name = re_NUMBER.sub('', name)
                 sym[name] = sym.get(name, 0) + int(size, 16)
     return sym
 
_
