From: akpm@linux-foundation.org
Subject: + checkpatch-look-for-common-misspellings.patch added to -mm tree
Date: Wed, 10 Sep 2014 15:52:30 -0700
Message-ID: <5410d62e.YmbTb4z+NNQN4oV4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaIJWwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Sep 2014 18:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, joe@perches.com, standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: look for common misspellings
has been added to the -mm tree.  Its filename is
     checkpatch-look-for-common-misspellings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-look-for-common-misspellings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-look-for-common-misspellings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: checkpatch: look for common misspellings

Check for misspellings, based on Debian's lintian list.  Several false
positives were removed, and several additional words added that were
common in the kernel:

	backword backwords
	invalide valide
	recieves
	singed unsinged

While going back and fixing existing spelling mistakes isn't a high
priority, it'd be nice to try to catch them before they hit the tree.

In the 13830 commits between 3.15 and 3.16, the script would have noticed
560 spelling mistakes. The top 25 are shown here:

$ git log --pretty=oneline v3.15..v3.16 | wc -l
13830
$ git log --format='%H' v3.15..v3.16 | \
   while read commit ; do \
     echo "commit $commit" ; \
     git log --format=email --stat -p -1 $commit | \
       ./scripts/checkpatch.pl --types=typo_spelling --no-summary - ; \
   done | tee spell_v3.15..v3.16.txt | grep "may be misspelled" | \
   awk '{print $2}' | tr A-Z a-z | sort | uniq -c | sort -rn
     21 'seperate'
     17 'endianess'
     15 'sucess'
     13 'noticable'
     11 'occured'
     11 'accomodate'
     10 'interrup'
      9 'prefered'
      8 'unecessary'
      8 'explicitely'
      7 'supress'
      7 'overriden'
      7 'immediatly'
      7 'funtion'
      7 'defult'
      7 'childs'
      6 'succesful'
      6 'splitted'
      6 'specifc'
      6 'reseting'
      6 'recieve'
      6 'changable'
      5 'tmis'
      5 'singed'
      5 'preceeding'

Thanks to Joe Perches for rewrites, suggestions, additional misspelling
entries, and testing.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   44 +
 scripts/spelling.txt  | 1042 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1085 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-look-for-common-misspellings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-look-for-common-misspellings
+++ a/scripts/checkpatch.pl
@@ -9,7 +9,8 @@ use strict;
 use POSIX;
 
 my $P = $0;
-$P =~ s@.*/@@g;
+$P =~ s@(.*)/@@g;
+my $D = $1;
 
 my $V = '0.32';
 
@@ -44,6 +45,7 @@ my $max_line_length = 80;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
+my $spelling_file = "$D/spelling.txt";
 
 sub help {
 	my ($exitcode) = @_;
@@ -434,6 +436,29 @@ our $allowed_asm_includes = qr{(?x:
 )};
 # memory.h: ARM has a custom one
 
+# Load common spelling mistakes and build regular expression list.
+my $misspellings;
+my @spelling_list;
+my %spelling_fix;
+open(my $spelling, '<', $spelling_file)
+    or die "$P: Can't open $spelling_file for reading: $!\n";
+while (<$spelling>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//g;
+	$line =~ s/^\s*//g;
+
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
+
+	my ($suspect, $fix) = split(/\|\|/, $line);
+
+	push(@spelling_list, $suspect);
+	$spelling_fix{$suspect} = $fix;
+}
+close($spelling);
+$misspellings = join("|", @spelling_list);
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
@@ -2220,6 +2245,23 @@ sub process {
 			    "8-bit UTF-8 used in possible commit log\n" . $herecurr);
 		}
 
+# Check for various typo / spelling mistakes
+		if ($in_commit_log || $line =~ /^\+/) {
+			while ($rawline =~ /(?:^|[^a-z@])($misspellings)(?:$|[^a-z@])/gi) {
+				my $typo = $1;
+				my $typo_fix = $spelling_fix{lc($typo)};
+				$typo_fix = ucfirst($typo_fix) if ($typo =~ /^[A-Z]/);
+				$typo_fix = uc($typo_fix) if ($typo =~ /^[A-Z]+$/);
+				my $msg_type = \&WARN;
+				$msg_type = \&CHK if ($file);
+				if (&{$msg_type}("TYPO_SPELLING",
+						 "'$typo' may be misspelled - perhaps '$typo_fix'?\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/(^|[^A-Za-z@])($typo)($|[^A-Za-z@])/$1$typo_fix$3/;
+				}
+			}
+		}
+
 # ignore non-hunk lines and lines being removed
 		next if (!$hunk_line || $line =~ /^-/);
 
diff -puN /dev/null scripts/spelling.txt
--- /dev/null
+++ a/scripts/spelling.txt
@@ -0,0 +1,1042 @@
+# Originally from Debian's Lintian tool. Various false positives have been
+# removed, and various additions have been made as they've been discovered
+# in the kernel source.
+#
+# License: GPLv2
+#
+# The format of each line is:
+# mistake||correction
+#
+abandonning||abandoning
+abigious||ambiguous
+abitrate||arbitrate
+abov||above
+abreviated||abbreviated
+absense||absence
+absolut||absolute
+absoulte||absolute
+acccess||access
+acceleratoin||acceleration
+accelleration||acceleration
+accesing||accessing
+accesnt||accent
+accessable||accessible
+accesss||access
+accidentaly||accidentally
+accidentually||accidentally
+accoding||according
+accomodate||accommodate
+accomodates||accommodates
+accordign||according
+accoring||according
+accout||account
+accquire||acquire
+accquired||acquired
+acessable||accessible
+acess||access
+achitecture||architecture
+acient||ancient
+acitions||actions
+acitve||active
+acknowldegement||acknowldegement
+acknowledgement||acknowledgment
+ackowledge||acknowledge
+ackowledged||acknowledged
+acording||according
+activete||activate
+acumulating||accumulating
+adapater||adapter
+addional||additional
+additionaly||additionally
+addres||address
+addreses||addresses
+addresss||address
+aditional||additional
+aditionally||additionally
+aditionaly||additionally
+adminstrative||administrative
+adress||address
+adresses||addresses
+adviced||advised
+afecting||affecting
+agaist||against
+albumns||albums
+alegorical||allegorical
+algorith||algorithm
+algorithmical||algorithmically
+algoritm||algorithm
+algoritms||algorithms
+algorrithm||algorithm
+algorritm||algorithm
+allign||align
+allocatrd||allocated
+allocte||allocate
+allpication||application
+alocate||allocate
+alogirhtms||algorithms
+alogrithm||algorithm
+alot||a lot
+alow||allow
+alows||allows
+altough||although
+alue||value
+ambigious||ambiguous
+amoung||among
+amout||amount
+analysator||analyzer
+ang||and
+anniversery||anniversary
+annoucement||announcement
+anomolies||anomalies
+anomoly||anomaly
+anway||anyway
+aplication||application
+appearence||appearance
+applicaion||application
+appliction||application
+applictions||applications
+appplications||applications
+appropiate||appropriate
+appropriatly||appropriately
+approriate||appropriate
+approriately||appropriately
+aquainted||acquainted
+aquired||acquired
+arbitary||arbitrary
+architechture||architecture
+arguement||argument
+arguements||arguments
+aritmetic||arithmetic
+arne't||aren't
+arraival||arrival
+artifical||artificial
+artillary||artillery
+assiged||assigned
+assigment||assignment
+assigments||assignments
+assistent||assistant
+assocation||association
+associcated||associated
+assotiated||associated
+assum||assume
+assumtpion||assumption
+asuming||assuming
+asycronous||asynchronous
+asynchnous||asynchronous
+atomatically||automatically
+atomicly||atomically
+attachement||attachment
+attched||attached
+attemps||attempts
+attruibutes||attributes
+authentification||authentication
+automaticaly||automatically
+automaticly||automatically
+automatize||automate
+automatized||automated
+automatizes||automates
+autonymous||autonomous
+auxilliary||auxiliary
+avaiable||available
+avaible||available
+availabe||available
+availabled||available
+availablity||availability
+availale||available
+availavility||availability
+availble||available
+availiable||available
+avalable||available
+avaliable||available
+aysnc||async
+backgroud||background
+backword||backward
+backwords||backwards
+bahavior||behavior
+bakup||backup
+baloon||balloon
+baloons||balloons
+bandwith||bandwidth
+batery||battery
+beacuse||because
+becasue||because
+becomming||becoming
+becuase||because
+beeing||being
+befor||before
+begining||beginning
+beter||better
+betweeen||between
+bianries||binaries
+bitmast||bitmask
+boardcast||broadcast
+borad||board
+boundry||boundary
+brievely||briefly
+broadcat||broadcast
+cacluated||calculated
+caculation||calculation
+calender||calendar
+calle||called
+calucate||calculate
+calulate||calculate
+cancelation||cancellation
+capabilites||capabilities
+capabitilies||capabilities
+capatibilities||capabilities
+carefuly||carefully
+cariage||carriage
+catagory||category
+challange||challenge
+challanges||challenges
+chanell||channel
+changable||changeable
+channle||channel
+channnel||channel
+charachter||character
+charachters||characters
+charactor||character
+charater||character
+charaters||characters
+charcter||character
+checksuming||checksumming
+childern||children
+childs||children
+chiled||child
+chked||checked
+chnage||change
+chnages||changes
+chnnel||channel
+choosen||chosen
+chouse||chose
+circumvernt||circumvent
+claread||cleared
+clared||cleared
+closeing||closing
+clustred||clustered
+collapsable||collapsible
+colorfull||colorful
+comand||command
+comit||commit
+commerical||commercial
+comming||coming
+comminucation||communication
+commited||committed
+commiting||committing
+committ||commit
+commoditiy||commodity
+compability||compatibility
+compaibility||compatibility
+compatability||compatibility
+compatable||compatible
+compatibiliy||compatibility
+compatibilty||compatibility
+compilant||compliant
+compleatly||completely
+completly||completely
+complient||compliant
+componnents||components
+compres||compress
+compresion||compression
+comression||compression
+comunication||communication
+conbination||combination
+conditionaly||conditionally
+conected||connected
+configuratoin||configuration
+configuraton||configuration
+configuretion||configuration
+conider||consider
+conjuction||conjunction
+connectinos||connections
+connnection||connection
+connnections||connections
+consistancy||consistency
+consistant||consistent
+containes||contains
+containts||contains
+contaisn||contains
+contant||contact
+contence||contents
+continous||continuous
+continously||continuously
+continueing||continuing
+contraints||constraints
+controled||controlled
+controler||controller
+controll||control
+contruction||construction
+contry||country
+convertion||conversion
+convertor||converter
+convienient||convenient
+convinient||convenient
+corected||corrected
+correponding||corresponding
+correponds||corresponds
+correspoding||corresponding
+cotrol||control
+couter||counter
+coutner||counter
+cryptocraphic||cryptographic
+cunter||counter
+curently||currently
+dafault||default
+deafult||default
+deamon||daemon
+decompres||decompress
+decription||description
+defailt||default
+defferred||deferred
+definate||definite
+definately||definitely
+defintion||definition
+defualt||default
+defult||default
+deivce||device
+delared||declared
+delare||declare
+delares||declares
+delaring||declaring
+delemiter||delimiter
+dependancies||dependencies
+dependancy||dependency
+dependant||dependent
+depreacted||deprecated
+depreacte||deprecate
+desactivate||deactivate
+desciptors||descriptors
+descrition||description
+descritptor||descriptor
+desctiptor||descriptor
+desriptor||descriptor
+desriptors||descriptors
+destory||destroy
+destoryed||destroyed
+destorys||destroys
+destroied||destroyed
+detabase||database
+develope||develop
+developement||development
+developped||developed
+developpement||development
+developper||developer
+developpment||development
+deveolpment||development
+devided||divided
+deviece||device
+diable||disable
+dictionnary||dictionary
+diferent||different
+differrence||difference
+difinition||definition
+diplay||display
+direectly||directly
+disapear||disappear
+disapeared||disappeared
+disappared||disappeared
+disconnet||disconnect
+discontinous||discontinuous
+dispertion||dispersion
+dissapears||disappears
+distiction||distinction
+docuentation||documentation
+documantation||documentation
+documentaion||documentation
+documment||document
+dorp||drop
+dosen||doesn
+downlad||download
+downlads||downloads
+druing||during
+dynmaic||dynamic
+easilly||easily
+ecspecially||especially
+edditable||editable
+editting||editing
+efficently||efficiently
+ehther||ether
+eigth||eight
+eletronic||electronic
+enabledi||enabled
+enchanced||enhanced
+encorporating||incorporating
+encrupted||encrypted
+encrypiton||encryption
+endianess||endianness
+enhaced||enhanced
+enlightnment||enlightenment
+enocded||encoded
+enterily||entirely
+enviroiment||environment
+enviroment||environment
+environement||environment
+environent||environment
+eqivalent||equivalent
+equiped||equipped
+equivelant||equivalent
+equivilant||equivalent
+eror||error
+estbalishment||establishment
+etsablishment||establishment
+etsbalishment||establishment
+excecutable||executable
+exceded||exceeded
+excellant||excellent
+existance||existence
+existant||existent
+exixt||exist
+exlcude||exclude
+exlcusive||exclusive
+exmaple||example
+expecially||especially
+explicite||explicit
+explicitely||explicitly
+explict||explicit
+explictly||explicitly
+expresion||expression
+exprimental||experimental
+extened||extended
+extensability||extensibility
+extention||extension
+extracter||extractor
+faild||failed
+faill||fail
+failue||failure
+failuer||failure
+faireness||fairness
+faliure||failure
+familar||familiar
+fatser||faster
+feauture||feature
+feautures||features
+fetaure||feature
+fetaures||features
+fileystem||filesystem
+finanize||finalize
+findn||find
+finilizes||finalizes
+finsih||finish
+flusing||flushing
+folloing||following
+followign||following
+follwing||following
+forseeable||foreseeable
+forse||force
+fortan||fortran
+forwardig||forwarding
+framwork||framework
+frequncy||frequency
+frome||from
+fucntion||function
+fuction||function
+fuctions||functions
+funcion||function
+functionallity||functionality
+functionaly||functionally
+functionnality||functionality
+functonality||functionality
+funtion||function
+funtions||functions
+furthur||further
+futhermore||furthermore
+futrue||future
+gaurenteed||guaranteed
+generiously||generously
+genric||generic
+globel||global
+grabing||grabbing
+grahical||graphical
+grahpical||graphical
+grapic||graphic
+guage||gauge
+guarentee||guarantee
+halfs||halves
+hander||handler
+handfull||handful
+hanled||handled
+harware||hardware
+heirarchically||hierarchically
+helpfull||helpful
+hierachy||hierarchy
+hierarchie||hierarchy
+howver||however
+hsould||should
+hypter||hyper
+identidier||identifier
+imblance||imbalance
+immeadiately||immediately
+immedaite||immediate
+immediatelly||immediately
+immediatly||immediately
+immidiate||immediate
+impelentation||implementation
+impementated||implemented
+implemantation||implementation
+implemenation||implementation
+implementaiton||implementation
+implementated||implemented
+implemention||implementation
+implemetation||implementation
+implemntation||implementation
+implentation||implementation
+implmentation||implementation
+implmenting||implementing
+incomming||incoming
+incompatabilities||incompatibilities
+incompatable||incompatible
+inconsistant||inconsistent
+increas||increase
+incrment||increment
+indendation||indentation
+indended||intended
+independant||independent
+independantly||independently
+independed||independent
+indiate||indicate
+inexpect||inexpected
+infomation||information
+informatiom||information
+informations||information
+informtion||information
+infromation||information
+ingore||ignore
+inital||initial
+initalised||initialized
+initalise||initialize
+initalize||initialize
+initation||initiation
+initators||initiators
+initializiation||initialization
+initialzed||initialized
+initilization||initialization
+initilize||initialize
+inofficial||unofficial
+instal||install
+inteface||interface
+integreated||integrated
+integrety||integrity
+integrey||integrity
+intendet||intended
+intented||intended
+interanl||internal
+interchangable||interchangeable
+interferring||interfering
+interger||integer
+intermittant||intermittent
+internel||internal
+interoprability||interoperability
+interrface||interface
+interrrupt||interrupt
+interrup||interrupt
+interrups||interrupts
+interruptted||interrupted
+interupted||interrupted
+interupt||interrupt
+intial||initial
+intialized||initialized
+intialize||initialize
+intregral||integral
+intrrupt||interrupt
+intuative||intuitive
+invaid||invalid
+invalde||invald
+invalide||invalid
+invididual||individual
+invokation||invocation
+invokations||invocations
+irrelevent||irrelevant
+isssue||issue
+itslef||itself
+jave||java
+jeffies||jiffies
+juse||just
+jus||just
+kown||known
+langage||language
+langauage||language
+langauge||language
+langugage||language
+lauch||launch
+leightweight||lightweight
+lengh||length
+lenght||length
+lenth||length
+lesstiff||lesstif
+libaries||libraries
+libary||library
+librairies||libraries
+libraris||libraries
+licenceing||licencing
+loggging||logging
+loggin||login
+logile||logfile
+loosing||losing
+losted||lost
+machinary||machinery
+maintainance||maintenance
+maintainence||maintenance
+maintan||maintain
+makeing||making
+malplaced||misplaced
+malplace||misplace
+managable||manageable
+managment||management
+mangement||management
+manoeuvering||maneuvering
+mappping||mapping
+mathimatical||mathematical
+mathimatic||mathematic
+mathimatics||mathematics
+maxium||maximum
+mechamism||mechanism
+meetign||meeting
+ment||meant
+mergable||mergeable
+mesage||message
+messags||messages
+messgaes||messages
+messsage||message
+messsages||messages
+microprocesspr||microprocessor
+milliseonds||milliseconds
+minumum||minimum
+miscelleneous||miscellaneous
+misformed||malformed
+mispelled||misspelled
+mispelt||misspelt
+miximum||maximum
+mmnemonic||mnemonic
+mnay||many
+modeled||modelled
+modulues||modules
+monochorome||monochrome
+monochromo||monochrome
+monocrome||monochrome
+mopdule||module
+mroe||more
+mulitplied||multiplied
+multidimensionnal||multidimensional
+multple||multiple
+mumber||number
+muticast||multicast
+mutiple||multiple
+mutli||multi
+nams||names
+navagating||navigating
+nead||need
+neccecary||necessary
+neccesary||necessary
+neccessary||necessary
+necesary||necessary
+negaive||negative
+negoitation||negotiation
+negotation||negotiation
+nerver||never
+nescessary||necessary
+nessessary||necessary
+noticable||noticeable
+notications||notifications
+notifed||notified
+numebr||number
+numner||number
+obtaion||obtain
+occassionally||occasionally
+occationally||occasionally
+occurance||occurrence
+occurances||occurrences
+occured||occurred
+occurence||occurrence
+occure||occurred
+occuring||occurring
+offet||offset
+omitt||omit
+ommiting||omitting
+ommitted||omitted
+onself||oneself
+ony||only
+operatione||operation
+opertaions||operations
+optionnal||optional
+optmizations||optimizations
+orientatied||orientated
+orientied||oriented
+otherise||otherwise
+ouput||output
+overaall||overall
+overhread||overhead
+overlaping||overlapping
+overriden||overridden
+overun||overrun
+pacakge||package
+pachage||package
+packacge||package
+packege||package
+packge||package
+packtes||packets
+pakage||package
+pallette||palette
+paln||plan
+paramameters||parameters
+paramater||parameter
+parametes||parameters
+parametised||parametrised
+paramter||parameter
+paramters||parameters
+particuarly||particularly
+particularily||particularly
+pased||passed
+passin||passing
+pathes||paths
+pecularities||peculiarities
+peformance||performance
+peice||piece
+pendantic||pedantic
+peprocessor||preprocessor
+perfoming||performing
+permissons||permissions
+peroid||period
+persistance||persistence
+persistant||persistent
+platfrom||platform
+plattform||platform
+pleaes||please
+ploting||plotting
+plugable||pluggable
+poinnter||pointer
+poiter||pointer
+posible||possible
+positon||position
+possibilites||possibilities
+powerfull||powerful
+preceeded||preceded
+preceeding||preceding
+preceed||precede
+precendence||precedence
+precission||precision
+prefered||preferred
+prefferably||preferably
+premption||preemption
+prepaired||prepared
+pressre||pressure
+primative||primitive
+princliple||principle
+priorty||priority
+privilaged||privileged
+privilage||privilege
+priviledge||privilege
+priviledges||privileges
+probaly||probably
+procceed||proceed
+proccesors||processors
+procesed||processed
+proces||process
+processessing||processing
+processess||processes
+processpr||processor
+processsed||processed
+processsing||processing
+procteted||protected
+prodecure||procedure
+progams||programs
+progess||progress
+programers||programmers
+programm||program
+programms||programs
+progresss||progress
+promps||prompts
+pronnounced||pronounced
+prononciation||pronunciation
+pronouce||pronounce
+pronunce||pronounce
+propery||property
+propigate||propagate
+propigation||propagation
+propogate||propagate
+prosess||process
+protable||portable
+protcol||protocol
+protecion||protection
+protocoll||protocol
+psudo||pseudo
+psuedo||pseudo
+psychadelic||psychedelic
+pwoer||power
+quering||querying
+raoming||roaming
+reasearcher||researcher
+reasearchers||researchers
+reasearch||research
+recepient||recipient
+receving||receiving
+recieved||received
+recieve||receive
+reciever||receiver
+recieves||receives
+recogniced||recognised
+recognizeable||recognizable
+recommanded||recommended
+recyle||recycle
+redircet||redirect
+redirectrion||redirection
+refcounf||refcount
+refence||reference
+refered||referred
+referenace||reference
+refering||referring
+refernces||references
+refernnce||reference
+refrence||reference
+registerd||registered
+registeresd||registered
+registes||registers
+registraration||registration
+regster||register
+regualar||regular
+reguator||regulator
+regulamentations||regulations
+reigstration||registration
+releated||related
+relevent||relevant
+remoote||remote
+remore||remote
+removeable||removable
+repectively||respectively
+replacable||replaceable
+replacments||replacements
+replys||replies
+reponse||response
+representaion||representation
+reqeust||request
+requiere||require
+requirment||requirement
+requred||required
+requried||required
+requst||request
+reseting||resetting
+resizeable||resizable
+resouces||resources
+resoures||resources
+ressizes||resizes
+ressource||resource
+ressources||resources
+retransmited||retransmitted
+retreived||retrieved
+retreive||retrieve
+retrive||retrieve
+retuned||returned
+reuest||request
+reuqest||request
+reutnred||returned
+rmeoved||removed
+rmeove||remove
+rmeoves||removes
+rountine||routine
+routins||routines
+rquest||request
+runing||running
+runned||ran
+runnning||running
+runtine||runtime
+sacrifying||sacrificing
+safly||safely
+safty||safety
+savable||saveable
+scaned||scanned
+scaning||scanning
+scarch||search
+seach||search
+searchs||searches
+secquence||sequence
+secund||second
+segement||segment
+senarios||scenarios
+sentivite||sensitive
+separatly||separately
+sepcify||specify
+sepc||spec
+seperated||separated
+seperately||separately
+seperate||separate
+seperatly||separately
+seperator||separator
+sepperate||separate
+sequece||sequence
+sequencial||sequential
+serveral||several
+setts||sets
+settting||setting
+shotdown||shutdown
+shoud||should
+shoule||should
+shrinked||shrunk
+siginificantly||significantly
+signabl||signal
+similary||similarly
+similiar||similar
+simlar||similar
+simliar||similar
+simpified||simplified
+singaled||signaled
+singal||signal
+singed||signed
+sleeped||slept
+softwares||software
+speach||speech
+specfic||specific
+speciefied||specified
+specifc||specific
+specifed||specified
+specificatin||specification
+specificaton||specification
+specifing||specifying
+specifiying||specifying
+speficied||specified
+speicify||specify
+speling||spelling
+spinlcok||spinlock
+spinock||spinlock
+splitted||split
+spreaded||spread
+sructure||structure
+stablilization||stabilization
+staically||statically
+staion||station
+standardss||standards
+standartization||standardization
+standart||standard
+staticly||statically
+stoped||stopped
+stoppped||stopped
+straming||streaming
+struc||struct
+structres||structures
+stuct||struct
+sturcture||structure
+subdirectoires||subdirectories
+suble||subtle
+succesfully||successfully
+succesful||successful
+successfull||successful
+sucessfully||successfully
+sucess||success
+superflous||superfluous
+superseeded||superseded
+suplied||supplied
+suported||supported
+suport||support
+suppored||supported
+supportin||supporting
+suppoted||supported
+suppported||supported
+suppport||support
+supress||suppress
+surpresses||suppresses
+susbsystem||subsystem
+suspicously||suspiciously
+swaping||swapping
+switchs||switches
+symetric||symmetric
+synax||syntax
+synchonized||synchronized
+syncronize||synchronize
+syncronizing||synchronizing
+syncronus||synchronous
+syste||system
+sytem||system
+sythesis||synthesis
+taht||that
+targetted||targeted
+targetting||targeting
+teh||the
+temorary||temporary
+temproarily||temporarily
+thier||their
+threds||threads
+threshhold||threshold
+throught||through
+thses||these
+tiggered||triggered
+tipically||typically
+tmis||this
+torerable||tolerable
+tramsmitted||transmitted
+tramsmit||transmit
+tranfer||transfer
+transciever||transceiver
+transferd||transferrd
+transfered||transferred
+transfering||transferring
+transision||transition
+transmittd||transmitted
+transormed||transformed
+trasmission||transmission
+treshold||threshold
+trigerring||triggering
+trun||turn
+ture||true
+tyep||type
+udpate||update
+uesd||used
+unconditionaly||unconditionally
+underun||underrun
+unecessary||unnecessary
+unexecpted||unexpected
+unexpectd||unexpected
+unexpeted||unexpected
+unfortunatelly||unfortunately
+unifiy||unify
+unknonw||unknown
+unknow||unknown
+unkown||unknown
+unneedingly||unnecessarily
+unresgister||unregister
+unsinged||unsigned
+unstabel||unstable
+unsuccessfull||unsuccessful
+unsuported||unsupported
+untill||until
+unuseful||useless
+upate||update
+usefule||useful
+usefull||useful
+usege||usage
+usera||users
+usualy||usually
+utilites||utilities
+utillities||utilities
+utilties||utilities
+utiltity||utility
+utitity||utility
+utitlty||utility
+vaid||valid
+vaild||valid
+valide||valid
+variantions||variations
+varient||variant
+vaule||value
+verbse||verbose
+verisons||versions
+verison||version
+verson||version
+vicefersa||vice-versa
+virtal||virtual
+virtaul||virtual
+virtiual||virtual
+visiters||visitors
+vitual||virtual
+wating||waiting
+whataver||whatever
+whenver||whenever
+wheter||whether
+whe||when
+wierd||weird
+wiil||will
+wirte||write
+withing||within
+wnat||want
+workarould||workaround
+writeing||writing
+writting||writing
+zombe||zombie
+zomebie||zombie
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-introduce-check_data_rlimit-helper-v2.patch
mm-use-may_adjust_brk-helper.patch
prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
lib-vsprintf-add-%pt-format-specifier.patch
checkpatch-look-for-common-misspellings.patch
linux-next.patch

